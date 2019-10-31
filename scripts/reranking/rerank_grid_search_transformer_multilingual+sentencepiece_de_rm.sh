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

data=$base/data/$src-$trg
scripts=$base/scripts

model_prefix=transformer_multilingual+sentencepiece

domains="law blogs"
in_domain=law

corpus=dev

for weight_combination in "0.1 0.1 0.8" "0.1 0.2 0.7" "0.1 0.3 0.6" "0.1 0.4 0.5" "0.1 0.5 0.4" "0.1 0.6 0.3" "0.1 0.7 0.2" "0.1 0.8 0.1" "0.2 0.1 0.7" "0.2 0.2 0.6" "0.2 0.3 0.5" "0.2 0.4 0.4" "0.2 0.5 0.3" "0.2 0.6 0.2" "0.3 0.1 0.6" "0.3 0.2 0.5" "0.3 0.3 0.4" "0.3 0.4 0.3" "0.3 0.5 0.2" "0.4 0.1 0.5" "0.4 0.2 0.4" "0.4 0.3 0.3" "0.4 0.4 0.2" "0.4 0.5 0.1" "0.5 0.1 0.4" "0.5 0.2 0.3" "0.5 0.3 0.2" "0.5 0.4 0.1" "0.6 0.1 0.3" "0.6 0.2 0.2" "0.7 0.1 0.2" "0.8 0.1 0.1"; do
  rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"

  model_name="${model_prefix}_${rerank_suffix}"

  echo "model_name: ${model_name}"
  echo "##############################"

  . $scripts/reranking/rerank_multilingual+sentencepiece_generic.sh
  . $scripts/evaluation/evaluate_reranked_generic.sh
done
