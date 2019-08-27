#! /bin/bash

data=$base/data/$src-$trg
scripts=$base/scripts

distillations=$base/distillations
mkdir -p $distillations

distillations=$base/distillations/$src-$trg
mkdir -p $distillations

mkdir -p $distillations/$model_name

num_threads=10

# translate train data

OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/$in_domain/train.pieces.$src \
            -o $distillations/$model_name/train.pieces.$model_name.$in_domain.$trg \
            -m $base/models/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            --device-ids 0 \
            --batch-size 100 \
            --disable-device-locking

# translate dev data

OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/$in_domain/dev.pieces.$src \
            -o $distillations/$model_name/dev.pieces.$model_name.$in_domain.$trg \
            -m $base/models/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            --device-ids 0 \
            --batch-size 100 \
            --disable-device-locking

# remove pieces because sentencepiece training in Sockeye expects truecased input

cat $distillations/$model_name/train.pieces.$model_name.$in_domain.$trg | \
  python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > \
  $distillations/$model_name/train.truecased.$model_name.$in_domain.$trg

cat $distillations/$model_name/dev.pieces.$model_name.$in_domain.$trg | \
  python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > \
  $distillations/$model_name/dev.truecased.$model_name.$in_domain.$trg
