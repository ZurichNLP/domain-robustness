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
trg=rm

in_domain=law

. $scripts/lm/preprocessing/preprocess_data_pieces_generic.sh
