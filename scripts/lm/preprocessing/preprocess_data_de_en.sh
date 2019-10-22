#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../../..
else
  base=$1
fi;

scripts=$base/scripts

src=de
trg=en

in_domain=medical

. $scripts/lm/preprocessing/preprocess_data_generic.sh
