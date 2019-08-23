#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

src=de
trg=en

model_name=rnn_reconstruction

in_domain=medical

domains="it koran law medical subtitles"

. $scripts/translation/translate_multilingual_generic.sh
