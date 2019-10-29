#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../../..
else
  base=$1
fi;

scripts=$base/scripts

src=de
trg=en

preprocessed_data=$data/$src-$trg/fairseq-preprocessed
model_name=fairseq-lm

. $scripts/lm/training/train_lm_generic.sh
