#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

src=de
trg=en

data=$base/data/$src-$trg
models=$base/models/$src-$trg
scripts=$base/scripts

mkdir -p $models

model_name=transformer_multilingual_tie2

mkdir -p $models/$model_name

train_source=$data/medical/train.bpe.multilingual.$src
train_target=$data/medical/train.bpe.multilingual.$trg

dev_source=$data/medical/dev.bpe.multilingual.$src
dev_target=$data/medical/dev.bpe.multilingual.$trg

. $scripts/training/train_transformer_tie2_generic.sh
