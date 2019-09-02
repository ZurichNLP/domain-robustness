#! /bin/bash

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

model_name=transformer

mkdir -p $models/$model_name

train_source=$data/law/train.bpe.$src
train_target=$data/law/train.bpe.$trg

dev_source=$data/law/dev.bpe.$src
dev_target=$data/law/dev.bpe.$trg

. $scripts/training/train_transformer_generic.sh
