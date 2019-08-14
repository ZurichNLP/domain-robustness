#!/bin/bash
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task 5
#SBATCH --mem 16g

sbatch --partition=hydra $1