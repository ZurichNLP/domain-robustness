#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

src=de
trg=rm

scripts=$base/scripts

model_prefix=transformer_reconstruction+sentencepiece

domains="law blogs"
in_domain=law

corpus=test

# find best with rerank_grid_search
weight_combination="0.3 0.3 0.2"

rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"

model_name="${model_prefix}_${rerank_suffix}"

echo "model_name: ${model_name}"
echo "##############################"

. $scripts/reranking/rerank_multilingual+sentencepiece_generic.sh
. $scripts/evaluation/evaluate_reranked_generic.sh
