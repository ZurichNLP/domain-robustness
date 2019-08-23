#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/..
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

# TODO: determine if lower for baselines!
sentencepiece_vocab_size=16000

. $scripts/preprocessing/preprocess_data_generic.sh
. $scripts/preprocessing/preprocess_out_of_domain_test_data_generic.sh
