#! /bin/bash

data=$base/data/$src-$trg
scripts=$base/scripts

distillations=$base/distillations
mkdir -p $distillations

distillations=$base/distillations/$src-$trg
mkdir -p $distillations

mkdir -p $distillations/$model_name

MOSES=$base/tools/moses-scripts/scripts

in_domain=medical

num_threads=10

OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/train.bpe.multilingual.$src \
            -o $distillations/$model_name/train.bpe.multilingual.$model_name.$in_domain.$trg \
            -m $base/models/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            --device-ids 0 \
            --batch-size 100 \
            --disable-device-locking

# no postprocessing needed for multilingual distillation
