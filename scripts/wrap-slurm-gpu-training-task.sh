#!/bin/bash

source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/sockeye3/bin/activate

module load volta cuda/9.1

sbatch --qos=vesta --time=24:00:00 --gres gpu:Tesla-V100:2 --cpus-per-task 4 --mem 48g $1 mode=sbatch
