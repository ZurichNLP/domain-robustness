#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts
models=$base/models
translations=$base/translations

# currently, there is only one source language
src=de

for trg in en rm; do
  for model_name in transformer transformer_multilingual transformer_sentencepiece transformer_reconstruction transformer_distillation; do

    if [[ -d $translations/$src-$trg/$model_name ]]; then
      . $scripts/evaluation/evaluate_${model_name}${src}_${trg}.sh
    fi
  done
done