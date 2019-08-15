#!/bin/bash

module load volta cuda/9.1

sbatch --qos=vesta --time=168:00:00 --gres gpu:Tesla-V100:4 --cpus-per-task 5 --mem 50g $1 mode=sbatch