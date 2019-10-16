#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

tools=$base/tools
mkdir -p $tools

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

# install torch

wget https://download.pytorch.org/whl/cu100/torch-1.3.0%2Bcu100-cp35-cp35m-linux_x86_64.whl

pip install torch-1.3.0+cu100-cp35-cp35m-linux_x86_64.whl

rm torch-1.3.0+cu100-cp35-cp35m-linux_x86_64.whl

# fairseq for language modelling

pip install fairseq
