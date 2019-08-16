#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

data=$base/data

translations=$base/translations
model_name=reconstruction

bleu=$base/bleu
mkdir -p $bleu

mkdir -p $bleu/$model_name

trg=en

for domain in it koran law medical subtitles; do

    data=$base/data/$domain

    # compute case-sensitive BLEU on detokenized data

    cat $translations/$model_name/test.$model_name.$domain.$trg | sacrebleu $data/test.$trg > $bleu/$model_name/test.$model_name.$domain.bleu

    echo "$bleu/$model_name/test.$model_name.$domain.bleu"
    cat $bleu/$model_name/test.$model_name.$domain.bleu

done
