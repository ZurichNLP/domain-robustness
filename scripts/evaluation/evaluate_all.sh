#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts
models=$base/models
translations=$base/translations

# currently, there is only one source language
src=de

for trg in en rm; do
  for model_name in for model_name in transformer_all transformer_multilingual transformer_multilingual+sentencepiece transformer_multilingual+sentencepiece_tie2 transformer_multilingual_tie2 transformer_reconstruction+sentencepiece transformer_reconstruction+sentencepiece_tie2 transformer_reconstruction_tie2 transformer_reconstruction_tinylr; do

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