#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

echo "the potentially medically important signs and symptoms" >> testfile

python $base/scripts/lm/score.py --model $base/models/de-en/fairseq-lm --input testfile

rm testfile
