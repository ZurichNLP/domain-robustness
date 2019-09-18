#!/bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

src=de
trg=rm

data=$base/data/$src-$trg
models=$base/models/$src-$trg
scripts=$base/scripts
shared_models=$base/shared_models

mkdir -p $models

model_name=transformer_reconstruction+sentencepiece
init_model_name=transformer_multilingual+sentencepiece

mkdir -p $models/$model_name

train_source=$data/law/train.truecased.multilingual.$src
train_target=$data/law/train.truecased.multilingual.$trg

dev_source=$data/law/dev.pieces.multilingual.$src
dev_target=$data/law/dev.pieces.multilingual.$trg

sentencepiece_model=$shared_models/$src$trg.law.sentencepiece.model

. $scripts/training/train_transformer_reconstruction+sentencepiece_generic.sh
