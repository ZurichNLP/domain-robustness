#! /bin/bash

# calling process needs to set:

# $input_src
# $input_trg
# $output
# $batch_size
# $model_path
# $max_seq_len
# $score_type

input_src=$1
input_trg=$2
output=$3
batch_size=$4
model_path=$5
max_seq_len=$6
score_type=$7

log_file=$output.log

OMP_NUM_THREADS=1 python -m sockeye.score \
        --source $input_src \
        --target $input_trg \
        -m $model_path \
        --length-penalty-alpha 1.0 \
        --device-ids 0 \
        --batch-size $batch_size \
        --disable-device-locking \
        --max-seq-len $max_seq_len:$max_seq_len \
        --score-type $score_type \
        --output $output 2>&1 | tee -a $log_file

