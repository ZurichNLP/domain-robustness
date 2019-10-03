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
shared_models=$base/shared_models

mkdir -p $models

model_name=transformer_sentencepiece

mkdir -p $models/$model_name

train_source=$data/medical/train.truecased.$src
train_target=$data/medical/train.truecased.$trg

dev_source=$data/medical/dev.pieces.$src
dev_target=$data/medical/dev.pieces.$trg

source_vocab=$shared_models/$src$trg.medical.sentencepiece.sockeye.vocab
target_vocab=$shared_models/$src$trg.medical.sentencepiece.sockeye.vocab

sentencepiece_model=$shared_models/$src$trg.medical.sentencepiece.model

. $scripts/training/train_transformer_sentencepiece_generic.sh
