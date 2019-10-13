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

model_name=transformer_reconstruction+sentencepiece

in_domain=law

domains="law blogs"

. $scripts/translation/translate_transformer_multilingual+sentencepiece_generic.sh
