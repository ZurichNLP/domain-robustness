#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../../..
else
  base=$1
fi;

src=de
trg=en

data=$base/data
models=$base/models/$src-$trg

preprocessed_data=$data/$src-$trg/fairseq-preprocessed

mkdir -p $models

model_name=fairseq-lm

mkdir -p $models/$model_name

fairseq-train --task language_modeling \
    $preprocessed_data \
    --save-dir $models/$model_name \
    --arch transformer_lm \
    --max-update 286000 \
    --max-lr 1.0 --t-mult 2 \
    --lr-period-updates 270000 \
    --lr-scheduler cosine \
    --lr-shrink 0.75 \
    --warmup-updates 16000 \
    --warmup-init-lr 1e-07 \
    --min-lr 1e-09 \
    --optimizer nag \
    --lr 0.0001 \
    --clip-norm 0.1 \
    --criterion label_smoothed_cross_entropy \
    --max-tokens 1024 \
    --update-freq 6 \
    --tokens-per-sample 1024 \
    --seed 1 \
    --sample-break-mode none \
    --skip-invalid-size-inputs-valid-test \
    --ddp-backend=no_c10d
