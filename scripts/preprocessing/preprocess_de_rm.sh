#! /bin/bash

# check if calling script has set $base
if [ $# -eq 0 ]; then
  script_dir=`dirname "$0"`
  base=$script_dir/../..
else
  base=$1
fi;

mkdir -p $base/shared_models

data=$base/data
scripts=$base/scripts
shared_models=$base/shared_models

src=de
trg=rm

domains="all law blogs"

MOSES=$base/tools/moses-scripts/scripts

bpe_num_operations=16000
bpe_vocab_threshold=10

# mirror final vocab size for Sockeye BPE training
sentencepiece_vocab_size=15254

. $scripts/preprocessing/preprocess_data_generic.sh
. $scripts/preprocessing/preprocess_out_of_domain_test_data_generic.sh
