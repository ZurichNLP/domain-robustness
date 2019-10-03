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

model_name=transformer_multilingual

in_domain=medical

. $scripts/distillation/distill_multilingual_generic.sh
