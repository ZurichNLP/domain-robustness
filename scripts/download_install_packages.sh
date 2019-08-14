#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

tools=$base/tools
mkdir -p $tools

echo "Make sure this script is executed AFTER you have activated a virtualenv"

# install Sockeye

# CUDA version on instance
CUDA_VERSION=91

## Method A: install from PyPi

# wget https://raw.githubusercontent.com/awslabs/sockeye/master/requirements/requirements.gpu-cu${CUDA_VERSION}.txt
# pip install sockeye --no-deps -r requirements.gpu-cu${CUDA_VERSION}.txt
# rm requirements.gpu-cu${CUDA_VERSION}.txt

## Method B: install from Github repo (uncomment if that's what you need)

git clone https://github.com/ZurichNLP/sockeye $tools/sockeye
(cd $tools/sockeye && git checkout reconstruction_niu)

pip install --no-deps -r $tools/sockeye/requirements/requirements.gpu-cu${CUDA_VERSION}.txt $tools/sockeye

pip install matplotlib mxboard

# install BPE library

pip install subword-nmt

# install sacrebleu for evaluation

pip install sacrebleu

# install Moses scripts for preprocessing

git clone https://github.com/bricksdont/moses-scripts $tools/moses-scripts
