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

    # produce nbest list, desired beam size, desired batch size

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/test.pieces.$src \
            -o $translations/$model_name/test.nbest.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --beam-size $beam_size \
            --nbest-size $beam_size \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size $batch_size \
            --disable-device-locking

    # 1-best, fixed beam size, fixed batch size

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/test.pieces.$src \
            -o $translations/$model_name/test.pieces.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size 64 \
            --disable-device-locking

    # undo pieces

    cat $translations/$model_name/test.pieces.$model_name.$domain.$trg | python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > $translations/$model_name/test.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $translations/$model_name/test.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $translations/$model_name/test.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $translations/$model_name/test.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/$model_name/test.$model_name.$domain.$trg

done