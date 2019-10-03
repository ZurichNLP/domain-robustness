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

model_name=rnn_reconstruction
init_model_name=rnn_multilingual

mkdir -p $models/$model_name

src=de
trg=en

reconstruction_loss_weight=0.1

train_source=$data/medical/train.multilingual.$src
train_target=$data/medical/train.multilingual.$trg

dev_source=$data/medical/dev.multilingual.$src
dev_target=$data/medical/dev.multilingual.$trg

. $scripts/training/train_rnn_reconstruction_generic.sh
