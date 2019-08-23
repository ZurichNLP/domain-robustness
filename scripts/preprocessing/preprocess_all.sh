#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

# currently, there is only one source language
src=de

for trg in en rm; do
  $scripts/wrap-slurm-cpu-task.sh $scripts/preprocessing/preprocess_${src}_${trg}.sh
done
