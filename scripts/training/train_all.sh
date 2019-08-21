#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts
models=$base/models

# currently, there is only one source language
src=de

for trg in en rm; do
  for model_name in rnn rnn_multilingual rnn_reconstruction transformer transformer_multilingual transformer_reconstruction; do

    if [[ -d $models/$src-$trg/model_name ]]; then
      $scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_${model_name}${src}_${trg}.sh
    fi
  done
done
