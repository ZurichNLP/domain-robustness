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

. $scripts/lm/training/train_lm_generic.sh
