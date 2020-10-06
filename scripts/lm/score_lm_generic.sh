#! /bin/bash

# calling process needs to set:

# $input
# $output
# $model_path
# $score_type
# $scripts

input=$1
output=$2
model_path=$3
score_type=$4
scripts=$5

log_file=$output.log

python $scripts/lm/score_lm.py \
    --input $input \
    --output $output \
    --model $model_path \
    --cuda \
    --score-type $score_type 2>&1 | tee -a $log_file

