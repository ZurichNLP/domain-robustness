#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

scripts=$base/scripts

src=de
trg=rm

model_name=transformer_sentencepiece_tie2

in_domain=law

domains="law blogs"

beam_size=50
batch_size=8

. $scripts/translation/translate_sentencepiece_generic.sh
. $scripts/translation/translate_sentencepiece_dev_generic.sh
