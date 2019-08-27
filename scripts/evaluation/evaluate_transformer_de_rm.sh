#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

scripts=$base/scripts

src=de
trg=rm

model_name=transformer

domains="law blogs"

. $scripts/evaluation/evaluate_generic.sh