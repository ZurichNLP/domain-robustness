#! /bin/bash

base=/net/cephfs/home/mathmu/scratch/domain-robustness
source $base/venvs/fairseq3/bin/activate

scripts=$base/scripts
data=$base/data
lm_preprocessed=$base/lm_preprocessed

mkdir -p $lm_preprocessed

src=de

num_workers=8

for trg in en rm; do

    if [[ $trg == "en" ]]; then
        in_domain=medical
    else
        in_domain=law
    fi

    data_sub=$data/$src-$trg/$in_domain

    for mode in bpe pieces; do

      preprocessed_lm_sub=$lm_preprocessed/$src-$trg/$mode

      if [[ -d $preprocessed_lm_sub ]]; then
          echo "Folder exists: $preprocessed_lm_sub"
          echo "Skipping."
          continue
      fi

      mkdir -p $preprocessed_lm_sub

      sbatch --cpus-per-task=8 --time=24:00:00 --mem=16G --partition=generic \
          $scripts/lm/preprocessing/preprocess_lm_generic.sh \
              $data_sub $preprocessed_lm_sub $trg $num_workers $mode

    done
done
