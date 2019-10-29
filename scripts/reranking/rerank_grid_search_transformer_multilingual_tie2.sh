#! /bin/bash

data=$base/data/$src-$trg
scripts=$base/scripts

model_name=transformer_multilingual_tie2

weight_combinations="0.1 0.1 0.8" "0.1 0.2 0.7" "0.1 0.3 0.6" "0.1 0.4 0.5" "0.1 0.5 0.4" "0.1 0.6 0.3" "0.1 0.7 0.2" "0.1 0.8 0.1" "0.2 0.1 0.7" "0.2 0.2 0.6" "0.2 0.3 0.5" "0.2 0.4 0.4" "0.2 0.5 0.3" "0.2 0.6 0.2" "0.3 0.1 0.6" "0.3 0.2 0.5" "0.3 0.3 0.4" "0.3 0.4 0.3" "0.3 0.5 0.2" "0.4 0.1 0.5" "0.4 0.2 0.4" "0.4 0.3 0.3" "0.4 0.4 0.2" "0.4 0.5 0.1" "0.5 0.1 0.4" "0.5 0.2 0.3" "0.5 0.3 0.2" "0.5 0.4 0.1" "0.6 0.1 0.3" "0.6 0.2 0.2" "0.7 0.1 0.2" "0.8 0.1 0.1"

for weight_combination in $weight_combinations; do
  rerank_prefix="$(echo -e "${weight_combination}" | tr -d '[:space:]')"
done