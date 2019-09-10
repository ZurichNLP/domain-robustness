#!/bin/bash

source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/sockeye3/bin/activate

module purge
module load rhel7/default-peta4
module add python-3.6.2-gcc-5.4.0-me5fsee

sbatch --cpus-per-task=64 --time=24:00:00 --mem=16G --partition=skylake $1 mode=sbatch