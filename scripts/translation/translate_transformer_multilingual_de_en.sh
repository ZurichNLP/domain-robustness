#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/../..
fi;

scripts=$base/scripts

src=de
trg=en

model_name=transformer_multilingual

in_domain=medical

domains="it koran law medical subtitles"

. $scripts/translation/translate_multilingual_generic.sh
