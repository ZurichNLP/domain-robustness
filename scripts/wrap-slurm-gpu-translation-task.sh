#!/bin/bash

source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/sockeye3/bin/activate

module purge
module load rhel7/default-peta4
module load cuda/9.1
module add python/3.5.1

# old

# sbatch --qos=vesta --time=24:00:00 --gres gpu:Tesla-V100:1 --cpus-per-task 10 \
#        --mem 10g $1 mode=sbatch

# new
sbatch -A T2-CS037-GPU --gres=gpu:1 --nodes=1 --time=24:00:00 --cpus-per-task 3 \
       --mem 10g $1 mode=sbatch
