#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../../..
else
  base=$1
fi;

scripts=$base/scripts
data=$base/data

src=de
trg=rm

preprocessed_data=$data/$src-$trg/fairseq-preprocessed-pieces
model_name=fairseq-lm-pieces

. $scripts/lm/training/train_lm_generic.sh
