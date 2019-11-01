#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts
models=$base/models
translations=$base/translations

# currently, there is only one source language
src=de

for trg in en rm; do
  for model_name in transformer transformer_distillation transformer_sentencepiece transformer_multilingual transformer_multilingual+sentencepiece transformer_multilingual+sentencepiece_tie2 transformer_multilingual_tie2 transformer_reconstruction+sentencepiece transformer_reconstruction+sentencepiece_tie2 transformer_reconstruction_tie2 transformer_reconstruction_tinylr; do
  #for model_name in transformer_multilingual transformer_multilingual+sentencepiece transformer_multilingual+sentencepiece_tie2 transformer_multilingual_tie2 transformer_reconstruction+sentencepiece transformer_reconstruction+sentencepiece_tie2 transformer_reconstruction_tie2 transformer_reconstruction_tinylr; do

    echo "###############################################"

    if [[ -d $models/$src-$trg/$model_name ]]; then
      echo "Model exists: $models/$src-$trg/$model_name"
      if [[ ! -d $translations/$src-$trg/$model_name ]]; then
        echo "Translations not found: $translations/$src-$trg/$model_name"
        $scripts/wrap-slurm-gpu-translation-task.sh $scripts/translation/translate_${model_name}_${src}_${trg}.sh
      else
        echo "Translations exist: $translations/$src-$trg/$model_name"
        echo "Skipping..."
      fi
    else
      echo "Model does not exist: $models/$src-$trg/$model_name"
      echo "Skipping..."
    fi
  done
done
