#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

echo "the potentially medically important signs and symptoms" >> infile

python $base/scripts/lm/score.py --model $base/models/de-en/fairseq-lm --input infile --output outfile
cat outfile
rm outfile
rm infile

# test case with UNK tokens, where the score should be -100

echo "the potentially medically Ver@@ Ukd@ signs and symptoms" >> infile

python $base/scripts/lm/score.py --model $base/models/de-en/fairseq-lm --input infile --output outfile --unk-penalty -100.0
cat outfile
rm outfile
rm infile
