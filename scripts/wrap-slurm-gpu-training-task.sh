#!/bin/bash

source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/sockeye3/bin/activate

module load volta cuda/9.1

sbatch --qos=vesta --time=168:00:00 --gres gpu:Tesla-V100:4 --cpus-per-task 5 --mem 50g $1 mode=sbatch
