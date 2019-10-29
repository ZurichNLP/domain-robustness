#! /bin/bash

data=$base/data
translations=$base/translations/$src-$trg
scores=$base/scores/$src-$trg

bleu=$base/bleu
mkdir -p $bleu

bleu=$base/bleu/$src-$trg
mkdir -p $bleu

mkdir -p $bleu/$model_name

echo "######################################################"
echo "NORMAL"
echo "######################################################"

for domain in $domains; do

    data=$base/data/$src-$trg/$domain

    # compute case-sensitive BLEU on detokenized data

    cat $translations/$model_name/test.$model_name.$domain.$trg | sacrebleu $data/test.$trg > $bleu/$model_name/test.$model_name.$domain.bleu

    echo "$bleu/$model_name/test.$model_name.$domain.bleu"
    cat $bleu/$model_name/test.$model_name.$domain.bleu

done

echo "######################################################"
echo "RERANKED"
echo "######################################################"

if [[ -d $scores/$model_name ]]; then

  bleu_reranked=$base/bleu_reranked
  mkdir -p $bleu_reranked

  bleu_reranked=$base/bleu_reranked/$src-$trg
  mkdir -p $bleu_reranked

  mkdir -p $bleu_reranked/$model_name

  for domain in $domains; do

      data=$base/data/$src-$trg/$domain

      # compute case-sensitive BLEU on detokenized data

      cat $scores/$model_name/test.reranked_best.$model_name.$domain.$trg | sacrebleu $data/test.$trg > $bleu_reranked/$model_name/test.reranked_best.$model_name.$domain.bleu

      echo "$bleu_reranked/$model_name/test.$model_name.$domain.bleu"
      cat $bleu_reranked/$model_name/test.$model_name.$domain.bleu

  done

else

  echo "Reranked best translations (in $scores/$model_name) do not seem to exist."

fi;
