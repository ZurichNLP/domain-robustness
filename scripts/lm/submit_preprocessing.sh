#! /bin/bash

if [[ `hostname` == 'login0' ]]; then
  # S3IT
  source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/fairseq3/bin/activate
  module use /sapps/etc/modules/start/
  module load volta cuda/10.0
else
  # CSD3
  source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/fairseq3/bin/activate
  module purge
  module load rhel7/default-peta4
  module load cuda/10.0
  module add python-3.6.2-gcc-5.4.0-me5fsee
fi;

# work around slurm placing scripts in var folder
if [[ `hostname` == 'login0' ]]; then
  # S3IT
  echo "Detected environment: S3IT"
  echo "base=/net/cephfs/home/mathmu/scratch/domain-robustness"
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
elif [[ `hostname` == 'login-e-2' ]]; then
  # CSD3
  echo "Detected environment: S3IT"
  echo "base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness"
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
else
  echo "Unknown host, cannot set 'base' variable!"
  exit
fi;

sbatch --cpus-per-task=64 --time=24:00:00 --mem=16G --partition=skylake $1 $base
