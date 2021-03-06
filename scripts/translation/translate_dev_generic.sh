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

# translate only in-domain dev

for domain in $in_domain; do

    data=$base/data/$src-$trg/$domain

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/dev.bpe.$src \
            -o $translations/$model_name/dev.nbest.$model_name.$domain.$trg \
            -m $base/models/$src-$trg/$model_name \
            --beam-size $beam_size \
            --nbest-size $beam_size \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size $batch_size \
            --disable-device-locking

    # extract 1-best from nbest JSON

    cat $translations/$model_name/dev.nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 1 > $translations/$model_name/dev.bpe.$model_name.$domain.$trg

    # undo BPE

    cat $translations/$model_name/dev.bpe.$model_name.$domain.$trg | sed -r 's/@@( |$)//g' > $translations/$model_name/dev.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $translations/$model_name/dev.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $translations/$model_name/dev.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $translations/$model_name/dev.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/$model_name/dev.$model_name.$domain.$trg

done