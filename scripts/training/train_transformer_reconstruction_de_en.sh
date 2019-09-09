#!/bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

src=de
trg=en

data=$base/data/$src-$trg
models=$base/models/$src-$trg
scripts=$base/scripts

mkdir -p $models

model_name=transformer_reconstruction
init_model_name=transformer_multilingual

mkdir -p $models/$model_name

src=de
trg=en

train_source=$data/medical/train.bpe.multilingual.$src
train_target=$data/medical/train.bpe.multilingual.$trg

dev_source=$data/medical/dev.bpe.multilingual.$src
dev_target=$data/medical/dev.bpe.multilingual.$trg

. $scripts/training/train_transformer_reconstruction_generic.sh
