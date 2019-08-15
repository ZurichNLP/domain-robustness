#!/bin/bash

source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/sockeye3/bin/activate

sbatch --cpus-per-task=5 --time=24:00:00 --mem=16G --partition=hydra $1 mode=sbatch