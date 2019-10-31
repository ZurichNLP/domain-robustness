#! /bin/bash

data=$base/data/$src-$trg
scripts=$base/scripts

scores=$base/scores
mkdir -p $scores

scores=$base/scores/$src-$trg
mkdir -p $scores

mkdir -p $scores/$model_name

MOSES=$base/tools/moses-scripts/scripts

translations=$base/translations/$src-$trg

if [[ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]]; then
  num_threads=64
  device_arg="--use-cpu"
else
  num_threads=3
  device_arg="--device-ids 0"
fi

for domain in $in_domain; do

    data=$base/data/$src-$trg/$domain

    # extract translations from JSON objects

    cat $translations/$model_name/dev.nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 50 > $scores/$model_name/dev.nbest.$model_name.$domain.$trg

    # for source, repeat each line as many times as size of nbest list

    cat $data/dev.bpe.$src | perl -ne 'print $_ x 50' > $scores/$model_name/dev.nbest.$model_name.$domain.$src

    # forward scoring

    OMP_NUM_THREADS=$num_threads python -m sockeye.score \
            --source $scores/$model_name/dev.nbest.$model_name.$domain.$src \
            --target $scores/$model_name/dev.nbest.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size 512 \
            --max-seq-len 512:512 \
            --score-type logprob \
            --disable-device-locking \
            --output $scores/$model_name/dev.tm_forward.$model_name.$domain.scores

    # backward scoring

    OMP_NUM_THREADS=$num_threads python -m sockeye.score \
            --source $scores/$model_name/dev.nbest.$model_name.$domain.$trg \
            --target $scores/$model_name/dev.nbest.$model_name.$domain.$src \
            -m $base/models/$src-$trg/$model_name \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size 512 \
            --max-seq-len 512:512 \
            --score-type logprob \
            --disable-device-locking \
            --output $scores/$model_name/dev.tm_backward.$model_name.$domain.scores

    # remove tags for LM scoring

    cat $scores/$model_name/dev.nbest.$model_name.$domain.$trg | python $scripts/remove_tag_from_translations.py --src-tag "<2$src>" --trg-tag "<2$trg>" > $scores/$model_name/dev.nbest_no_tags.$model_name.$domain.$trg

    # hackish, but: activate fairseq3 venv

    source $base/venvs/fairseq3/bin/activate

    # fairseq LM scoring of target side

    python $scripts/lm/score.py --model-dir $base/models/$src-$trg/fairseq-lm \
                                --input $scores/$model_name/dev.nbest_no_tags.$model_name.$domain.$trg \
                                --output $scores/$model_name/dev.lm.$model_name.$domain.scores \
                                --unk-penalty -100.0

    # re-activate sockeye venv

    source $base/venvs/sockeye3/bin/activate

    # add all scores to nbest JSON

    python $scripts/add_scores_to_nbest.py --nbest $translations/$model_name/dev.nbest.$model_name.$domain.$trg \
            --scores $scores/$model_name/dev.lm.$model_name.$domain.scores \
                     $scores/$model_name/dev.tm_forward.$model_name.$domain.scores \
                     $scores/$model_name/dev.tm_backward.$model_name.$domain.scores \
            --names "scores_lm" "scores_tm_forward" "scores_tm_backward" \
            > $scores/$model_name/dev.all_scores.$model_name.$domain.$trg

done
