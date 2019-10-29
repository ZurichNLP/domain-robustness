#! /bin/bash

data=$base/data
reranked=$base/reranked/$src-$trg

if [[ -d $reranked/$model_name ]]; then

  bleu_reranked=$base/bleu_reranked
  mkdir -p $bleu_reranked

  bleu_reranked=$base/bleu_reranked/$src-$trg
  mkdir -p $bleu_reranked

  mkdir -p $bleu_reranked/$model_name

  for domain in $domains; do

      data=$base/data/$src-$trg/$domain

      # compute case-sensitive BLEU on detokenized data

      cat $reranked/$model_name/test.reranked_best.$model_name.$domain.$trg | sacrebleu $data/test.$trg > $bleu_reranked/$model_name/test.reranked_best.$model_name.$domain.bleu

      echo "$bleu_reranked/$model_name/test.reranked_best.$model_name.$domain.bleu"
      cat $bleu_reranked/$model_name/test.reranked_best.$model_name.$domain.bleu

  done

else

  echo "Reranked best translations (in $reranked/$model_name) do not seem to exist."

fi;
