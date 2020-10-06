#! /bin/bash

base=/net/cephfs/home/mathmu/scratch/domain-robustness
source $base/venvs/fairseq3/bin/activate
module load volta cuda/10.0

scripts=$base/scripts
lm_preprocessed=$base/lm_preprocessed
lm_models=$base/lm_models

mkdir -p $lm_models

src=de

for trg in en rm; do
    for mode in bpe pieces; do

      preprocessed_lm_sub=$lm_preprocessed/$src-$trg/$mode
      lm_models_sub=$lm_models/$src-$trg/$mode

      if [[ -d $lm_models_sub ]]; then
          echo "Folder exists: $lm_models_sub"
          echo "Skipping."
          continue
      fi

      mkdir -p $lm_models_sub

      sbatch --qos=vesta --time=48:00:00 --gres gpu:Tesla-V100-32GB:1  --cpus-per-task 1 --mem 16g \
          $scripts/lm/training/train_lm_generic.sh \
              $preprocessed_lm_sub $lm_models_sub

    done
done
