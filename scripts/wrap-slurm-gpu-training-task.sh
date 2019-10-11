#!/bin/bash

if [[ `hostname` == 'login0' ]]; then
  # S3IT
  source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/sockeye3/bin/activate
  module load volta cuda/9.1
else
  # CSD3
  source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/sockeye3/bin/activate
  module purge
  module load rhel7/default-peta4
  module load cuda/9.1
  module add python-3.6.2-gcc-5.4.0-me5fsee
fi;

# work around slurm placing scripts in var folder
if [[ `hostname` == 'login0' ]]; then
  # S3IT
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
elif [[ `hostname` == 'login-e-2' ]]; then
  # CSD3
  base=/rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness
else
  echo "Unknown host, cannot set 'base' variable!"
  exit
fi;

if [[ `hostname` == 'login0' ]]; then
  # S3IT
  sbatch --qos=vesta --time=24:00:00 --gres gpu:Tesla-V100:1 --cpus-per-task 3 --mem 48g $1 $base
else
  # CSD3
  sbatch -A T2-CS037-GPU --gres=gpu:1 --nodes=1 --time=36:00:00 --cpus-per-task 3 -p pascal $1 $base
fi;
