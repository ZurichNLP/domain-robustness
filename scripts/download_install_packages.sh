#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

tools=$base/tools
mkdir -p $tools


if [[ `hostname` == 'login0' ]]; then
  # S3IT
  source /net/cephfs/home/mathmu/scratch/domain-robustness/venvs/sockeye3/bin/activate
  module use /sapps/etc/modules/start/
  module load volta cuda/9.2
else
  # CSD3
  source /rds/project/t2_vol4/rds-t2-cs037/mmueller/domain-robustness/venvs/sockeye3/bin/activate
  module purge
  module load rhel7/default-peta4
  module load cuda/9.1
  module add python-3.6.2-gcc-5.4.0-me5fsee
fi;

# install Sockeye

# CUDA version on instance
CUDA_VERSION=92

## Method A: install from PyPi

# wget https://raw.githubusercontent.com/awslabs/sockeye/master/requirements/requirements.gpu-cu${CUDA_VERSION}.txt
# pip install sockeye --no-deps -r requirements.gpu-cu${CUDA_VERSION}.txt
# rm requirements.gpu-cu${CUDA_VERSION}.txt

## Method B: install from Github repo (uncomment if that's what you need)

git clone https://github.com/ZurichNLP/sockeye $tools/sockeye
(cd $tools/sockeye && git checkout reconstruction_niu)

# work around .git issue on lustre file systems
mv $tools/sockeye/.git $tools/.git

pip install --no-deps -r $tools/sockeye/requirements/requirements.gpu-cu${CUDA_VERSION}.txt $tools/sockeye

# work around .git issue on lustre file systems
mv $tools/.git $tools/sockeye/.git

# https://github.com/awslabs/sockeye/issues/693
pip install --upgrade numpy==1.16.1

pip install matplotlib mxboard

# install BPE library

pip install subword-nmt

# install sacrebleu for evaluation

pip install sacrebleu

# install Moses scripts for preprocessing

git clone https://github.com/bricksdont/moses-scripts $tools/moses-scripts

# install sentencepiece for subword regularization

pip install sentencepiece

# install fairseq for language models

pip install fairseq
