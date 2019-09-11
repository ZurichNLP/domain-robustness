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
distillations=$base/distillations/$src-$trg

mkdir -p $models

model_name=transformer_distillation
init_model_name=transformer

mkdir -p $models/$model_name

in_domain=medical

train_source=$data/$in_domain/train.bpe.$src
train_target=$distillations/$init_model_name/train.bpe.$init_model_name.$in_domain.$trg

dev_source=$data/$in_domain/dev.bpe.$src
dev_target=$distillations/$init_model_name/dev.bpe.$init_model_name.$in_domain.$trg

. $scripts/training/train_transformer_distillation_generic.sh
