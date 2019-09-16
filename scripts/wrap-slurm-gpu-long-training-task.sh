#!/bin/bash

source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/sockeye3/bin/activate

module purge
module load rhel7/default-peta4
module load cuda/9.1
module add python-3.6.2-gcc-5.4.0-me5fsee


# new
sbatch -A T2-CS037-GPU --gres=gpu:1 --nodes=1 --time=36:00:00 --cpus-per-task 3 \
       -p pascal-long $1 mode=sbatch
