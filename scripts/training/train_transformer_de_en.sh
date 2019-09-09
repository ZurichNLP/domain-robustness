#! /bin/bash

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

model_name=transformer

mkdir -p $models/$model_name

train_source=$data/medical/train.bpe.$src
train_target=$data/medical/train.bpe.$trg

dev_source=$data/medical/dev.bpe.$src
dev_target=$data/medical/dev.bpe.$trg

. $scripts/training/train_transformer_generic.sh
