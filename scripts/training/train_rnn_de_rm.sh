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

model_name=rnn

mkdir -p $models/$model_name

train_source=$data/law/train.bpe.$src
train_target=$data/law/train.bpe.$trg

dev_source=$data/law/dev.bpe.$src
dev_target=$data/law/dev.bpe.$trg

. $scripts/training/train_rnn_generic.sh
