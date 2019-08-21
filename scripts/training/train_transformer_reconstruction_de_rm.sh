#!/bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

src=de
trg=rm

data=$base/data/$src-$trg
models=$base/models/$src-$trg
scripts=$base/scripts

mkdir -p $models

model_name=transformer_reconstruction
init_model_name=transformer_multilingual

mkdir -p $models/$model_name

src=de
trg=en

train_source=$data/medical/train.multilingual.$src
train_target=$data/medical/train.multilingual.$trg

dev_source=$data/medical/dev.multilingual.$src
dev_target=$data/medical/dev.multilingual.$trg

. $scripts/training/train_transformer_reconstruction_generic.sh
