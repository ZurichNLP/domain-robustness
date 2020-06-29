#! /bin/bash

# calling script needs to set:
# $data_sub
# $bleu_reranked_sub
# $reranked_sub
# $model_name
# $domain
# $corpus
# $trg

data_sub=$1
bleu_reranked_sub=$2
reranked_sub=$3
model_name=$4
domain=$5
corpus=$6
trg=$7

# compute case-sensitive BLEU on detokenized data

cat $reranked_sub/$corpus.reranked_best.$model_name.$domain.$trg | \
    sacrebleu $data_sub/$corpus.$trg > \
        $bleu_reranked_sub/$corpus.reranked_best.$model_name.$domain.bleu

echo "$bleu_reranked_sub/$corpus.reranked_best.$model_name.$domain.bleu"
cat $bleu_reranked_sub/$corpus.reranked_best.$model_name.$domain.bleu
