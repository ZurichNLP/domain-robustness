#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

src=de
trg=rm

data=$base/data/$src-$trg
models=$base/models/$src-$trg
scripts=$base/scripts

mkdir -p $models

model_name=transformer_multilingual

mkdir -p $models/$model_name

train_source=$data/law/train.bpe.multilingual.$src
train_target=$data/law/train.bpe.multilingual.$trg

dev_source=$data/law/dev.bpe.multilingual.$src
dev_target=$data/law/dev.bpe.multilingual.$trg

. $scripts/training/train_transformer_generic.sh
