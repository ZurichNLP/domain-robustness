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

src=de
trg=en

domains="all it koran law medical subtitles"

MOSES=$base/tools/moses-scripts/scripts

bpe_num_operations=32000
bpe_vocab_threshold=10

. $scripts/preprocessing/preprocess_data_generic.sh
. $scripts/preprocessing/preprocess_out_of_domain_test_data_generic.sh
