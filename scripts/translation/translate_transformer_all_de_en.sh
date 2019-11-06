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

model_name=transformer_all

in_domain=all

domains="it koran law medical subtitles"

beam_size=50
batch_size=8

. $scripts/translation/translate_generic.sh
. $scripts/translation/translate_dev_generic.sh
