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
trg=en

model_name=transformer_sentencepiece

in_domain=medical

domains="it koran law medical subtitles"

. $scripts/translation/translate_sentencepiece_generic.sh
. $scripts/translation/translate_sentencepiece_dev_generic.sh
