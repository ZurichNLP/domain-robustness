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

for domain in $in_domain; do

    data=$base/data/$src-$trg/$domain

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/dev.pieces.$src \
            -o $translations/$model_name/dev.nbest.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --beam-size $beam_size \
            --nbest-size $beam_size \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size $batch_size \
            --disable-device-locking

    # extract 1-best from nbest JSON

    cat $translations/$model_name/dev.nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 1 > $translations/$model_name/dev.pieces.$model_name.$domain.$trg

    # undo pieces

    cat $translations/$model_name/dev.pieces.$model_name.$domain.$trg | python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > $translations/$model_name/dev.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $translations/$model_name/dev.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $translations/$model_name/dev.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $translations/$model_name/dev.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/$model_name/dev.$model_name.$domain.$trg

done