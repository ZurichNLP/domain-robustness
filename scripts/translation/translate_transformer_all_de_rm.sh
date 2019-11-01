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

model_name=transformer_all

in_domain=law

domains="law blogs"

beam_size=50
batch_size=8

. $scripts/translation/translate_generic.sh
. $scripts/translation/translate_dev_generic.sh