#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

python $base/scripts/lm/sample.py --model $base/lm_models/de-en/bpe --prefix "the potentially medically important signs and symptoms" --verbose
