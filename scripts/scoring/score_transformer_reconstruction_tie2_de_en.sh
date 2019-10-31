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

model_name=transformer_reconstruction_tie2

in_domain=medical

domains="it koran law medical subtitles"

corpus=test

. $scripts/scoring/score_multilingual_generic.sh

corpus=dev

. $scripts/scoring/score_generic.sh
