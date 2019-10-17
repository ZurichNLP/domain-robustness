#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

python sample.py --model $base/models/fairseq-lm --prefix "the potentially medically important signs and symptoms"