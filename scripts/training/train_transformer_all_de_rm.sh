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

model_name=transformer_all

mkdir -p $models/$model_name

train_source=$data/all/train.bpe.$src
train_target=$data/all/train.bpe.$trg

dev_source=$data/all/dev.bpe.$src
dev_target=$data/all/dev.bpe.$trg

. $scripts/training/train_transformer_generic.sh
