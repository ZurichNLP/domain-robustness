#! /bin/bash

data=$base/data
translations=$base/translations/$src-$trg

bleu=$base/bleu
mkdir -p $bleu

bleu=$base/bleu/$src-$trg
mkdir $bleu

mkdir -p $bleu/$model_name

domains="it koran law medical subtitles"

for domain in $domains; do

    data=$base/data/$domain

    # compute case-sensitive BLEU on detokenized data

    cat $translations/$model_name/test.$model_name.$domain.$trg | sacrebleu $data/test.$trg > $bleu/$model_name/test.$model_name.$domain.bleu

    echo "$bleu/$model_name/test.$model_name.$domain.bleu"
    cat $bleu/$model_name/test.$model_name.$domain.bleu

done