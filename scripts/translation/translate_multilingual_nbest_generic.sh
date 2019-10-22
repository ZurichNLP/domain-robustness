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
            -i $data/test.bpe.tag.$src \
            -o $translations/$model_name/test.bpe.tag.$model_name.$domain.$trg.nbest.json \
            -m $base/models/$src-$trg/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            $device_arg \
            --batch-size 64 \
            --nbest-size 10 \
            --disable-device-locking

done
