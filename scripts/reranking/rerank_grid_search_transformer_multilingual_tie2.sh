#! /bin/bash

src=de
trg=en

data=$base/data/$src-$trg
scripts=$base/scripts

model_prefix=transformer_multilingual_tie2

weight_combinations="0.1 0.1 0.8" "0.1 0.2 0.7" "0.1 0.3 0.6" "0.1 0.4 0.5" "0.1 0.5 0.4" "0.1 0.6 0.3" "0.1 0.7 0.2" "0.1 0.8 0.1" "0.2 0.1 0.7" "0.2 0.2 0.6" "0.2 0.3 0.5" "0.2 0.4 0.4" "0.2 0.5 0.3" "0.2 0.6 0.2" "0.3 0.1 0.6" "0.3 0.2 0.5" "0.3 0.3 0.4" "0.3 0.4 0.3" "0.3 0.5 0.2" "0.4 0.1 0.5" "0.4 0.2 0.4" "0.4 0.3 0.3" "0.4 0.4 0.2" "0.4 0.5 0.1" "0.5 0.1 0.4" "0.5 0.2 0.3" "0.5 0.3 0.2" "0.5 0.4 0.1" "0.6 0.1 0.3" "0.6 0.2 0.2" "0.7 0.1 0.2" "0.8 0.1 0.1"

domains="it koran law medical subtitles"

for weight_combination in $weight_combinations; do
  rerank_suffix="$(echo -e "${weight_combination}" | tr -d '[:space:]')"

  model_name="${model_prefix}_${rerank_suffix}"

  . $scripts/reranking/rerank_multilingual_generic.sh
  . $scripts/evaluation/evaluate_reranked_generic.sh
done
