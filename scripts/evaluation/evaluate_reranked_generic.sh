#! /bin/bash

data=$base/data
reranked=$base/reranked/$src-$trg

if [[ -d $reranked/$model_prefix ]]; then

  bleu_reranked=$base/bleu_reranked
  mkdir -p $bleu_reranked

  bleu_reranked=$base/bleu_reranked/$src-$trg
  mkdir -p $bleu_reranked

  mkdir -p $bleu_reranked/$model_prefix
  mkdir -p $bleu_reranked/$model_prefix/$rerank_suffix

  if [[ $corpus == 'dev' ]]; then
    domains=$in_domain
  fi

  for domain in $domains; do

      data=$base/data/$src-$trg/$domain

      # compute case-sensitive BLEU on detokenized data

      cat $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.$trg | sacrebleu $data/$corpus.$trg > $bleu_reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu

      # symlink to best translation

      ln -s $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.$trg $bleu_reranked/$model_prefix/$corpus.reranked_best.$model_name.$domain.$trg

      echo "$bleu_reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu"
      cat $bleu_reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.bleu

  done

else

  echo "Reranked best dev translations (in $reranked/$model_prefix) do not seem to exist."

fi;
