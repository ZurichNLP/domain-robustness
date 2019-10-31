#! /bin/bash

data=$base/data
reranked=$base/reranked/$src-$trg

if [[ -d $reranked/$model_name ]]; then

  bleu_reranked=$base/bleu_reranked
  mkdir -p $bleu_reranked

  bleu_reranked=$base/bleu_reranked/$src-$trg
  mkdir -p $bleu_reranked

  mkdir -p $bleu_reranked/$model_name
  mkdir -p $bleu_reranked/$model_name/$rerank_suffix

  if [[ $corpus == 'dev' ]]; then
    domains=$in_domain
  fi

  for domain in $domains; do

      data=$base/data/$src-$trg/$domain

      # compute case-sensitive BLEU on detokenized data

      cat $reranked/$model_name/$corpus.reranked_best.$model_name.$domain.$trg | sacrebleu $data/dev.$trg > $bleu_reranked/$model_name/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu

      echo "$bleu_reranked/$model_name/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu"
      cat $bleu_reranked/$model_name/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu

  done

else

  echo "Reranked best dev translations (in $reranked/$model_name) do not seem to exist."

fi;
