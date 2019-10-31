#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts
models=$base/models
translations=$base/translations

# currently, there is only one source language
src=de

for trg in en rm; do
  for model_name in $models/$src-$trg/*; do

    if [[ -d $base/translations/$src-$trg/$model_name ]]; then
      echo "Translations exist: $base/translations/$src-$trg/$model_name"
      if [[ -d $base/bleu/$src-$trg/$model_name ]]; then
        echo "BLEU scores exist: $base/bleu/$src-$trg/$model_name"
        echo "Will skip!"
      else
        echo "#"
        . $scripts/evaluation/evaluate_generic.sh
      fi
    fi
  done
done