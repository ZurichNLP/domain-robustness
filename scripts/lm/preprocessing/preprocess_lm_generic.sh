#! /bin/bash

# calling script needs to set:

# $data_sub
# $preprocessed_lm_sub
# $trg
# $num_workers
# $mode

data_sub=$1
preprocessed_lm_sub=$2
trg=$3
num_workers=$4
mode=$5

log_file=$preprocessed_lm_sub/log

fairseq-preprocess \
     --only-source \
     --trainpref $data_sub/train.$mode.$trg \
     --validpref $data_sub/dev.$mode.$trg \
     --testpref $data_sub/test.$mode.$trg \
     --destdir $preprocessed_lm_sub \
     --workers $num_workers 2>&1 | tee -a $log_file
