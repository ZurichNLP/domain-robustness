#! /bin/bash

data=$base/data/$src-$trg
scripts=$base/scripts

translations=$base/translations
mkdir -p $translations

translations=$base/translations/$src-$trg
mkdir -p $translations

mkdir -p $translations/$model_name

MOSES=$base/tools/moses-scripts/scripts

if [[ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]]; then
  num_threads=64
  device_arg="--use-cpu"
else
  num_threads=3
  device_arg="--device-ids 0"
fi

for domain in $domains; do

    data=$base/data/$src-$trg

    if [[ $domain != $in_domain ]]; then
      data=$data/$domain/test_unknown_domain/$in_domain
    else
      data=$data/$domain
    fi

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/test.pieces.tag.$src \
            -o $translations/$model_name/test.nbest.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --beam-size $beam_size \
            --nbest-size $beam_size \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size $batch_size \
            --disable-device-locking

    # extract 1-best from nbest JSON

    cat $translations/$model_name/test.nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 1 > $translations/$model_name/test.pieces.tag.$model_name.$domain.$trg

    # remove target language tag

    cat $translations/$model_name/test.pieces.tag.$model_name.$domain.$trg | python $scripts/remove_tag_from_translations.py --src-tag "<2$src>" --trg-tag "<2$trg>" > $translations/$model_name/test.pieces.$model_name.$domain.$trg

    # undo pieces

    cat $translations/$model_name/test.pieces.$model_name.$domain.$trg | python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > $translations/$model_name/test.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $translations/$model_name/test.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $translations/$model_name/test.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $translations/$model_name/test.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/$model_name/test.$model_name.$domain.$trg

done