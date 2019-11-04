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

for weight_combination in "0.0 0.0 1.0"	"0.0 0.1 0.9"	"0.0 0.2 0.8"	"0.0 0.3 0.7"	"0.0 0.4 0.6"	"0.0 0.5 0.5"	"0.0 0.6 0.4"	"0.0 0.7 0.3"	"0.0 0.8 0.2"	"0.0 0.9 0.1"	"0.0 1.0 0.0"	"0.1 0.0 0.9"	"0.1 0.1 0.8"	"0.1 0.2 0.7"	"0.1 0.3 0.6"	"0.1 0.4 0.5"	"0.1 0.5 0.4"	"0.1 0.6 0.3"	"0.1 0.7 0.2"	"0.1 0.8 0.1"	"0.1 0.9 0.0"	"0.2 0.0 0.8"	"0.2 0.1 0.7"	"0.2 0.2 0.6"	"0.2 0.3 0.5"	"0.2 0.4 0.4"	"0.2 0.5 0.3"	"0.2 0.6 0.2"	"0.2 0.8 0.0"	"0.3 0.0 0.7"	"0.3 0.1 0.6"	"0.3 0.2 0.5"	"0.3 0.3 0.4" "0.3 0.4 0.3"	"0.3 0.5 0.2"	"0.3 0.7 0.0"	"0.4 0.0 0.6"	"0.4 0.1 0.5"	"0.4 0.2 0.4"	"0.4 0.3 0.3"	"0.4 0.4 0.2"	"0.4 0.5 0.1"	"0.4 0.6 0.0"	"0.5 0.0 0.5"	"0.5 0.1 0.4"	"0.5 0.2 0.3"	"0.5 0.3 0.2"	"0.5 0.4 0.1"	"0.5 0.5 0.0"	"0.6 0.0 0.4" "0.6 0.1 0.3"	"0.6 0.2 0.2"	"0.6 0.4 0.0"	"0.7 0.0 0.3"	"0.7 0.1 0.2"	"0.7 0.3 0.0"	"0.8 0.0 0.2"	"0.8 0.1 0.1"	"0.8 0.2 0.0"	"0.9 0.0 0.1"	"0.9 0.1 0.0"	"1.0 0.0 0.0"; do
  rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"

  model_name="${model_prefix}_${rerank_suffix}"

  echo "model_name: ${model_name}"
  echo "##############################"

  . $scripts/reranking/rerank_multilingual+sentencepiece_generic.sh
  . $scripts/evaluation/evaluate_reranked_generic.sh
done

mkdir -p $base/grid_results
mkdir -p $base/grid_results/$src-$trg
mkdir -p $base/grid_results/$src-$trg/$model_prefix

python $scripts/filter_reranked_results.py --bleu-reranked-model-folder $base/bleu_reranked/$src-$trg/$model_prefix > $base/grid_results/$src-$trg/$model_prefix/result

cat $base/grid_results/$src-$trg/$model_prefix/result
