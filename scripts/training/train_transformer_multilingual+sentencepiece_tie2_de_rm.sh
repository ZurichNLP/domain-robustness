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
shared_models=$base/shared_models

mkdir -p $models

model_name=transformer_multilingual+sentencepiece_tie2

mkdir -p $models/$model_name

train_source=$data/law/train.truecased.multilingual.$src
train_target=$data/law/train.truecased.multilingual.$trg

dev_source=$data/law/dev.pieces.multilingual.$src
dev_target=$data/law/dev.pieces.multilingual.$trg

sentencepiece_model=$shared_models/$src$trg.law.sentencepiece.model

source_vocab=$shared_models/$src$trg.law.sentencepiece.multilingual.sockeye.vocab
target_vocab=$shared_models/$src$trg.law.sentencepiece.multilingual.sockeye.vocab

. $scripts/training/train_transformer_multilingual+sentencepiece_tie2_generic.sh
