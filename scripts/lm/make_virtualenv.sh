#! /bin/bash

# virtualenv must be installed on your system, install with e.g.
# pip install virtualenv

scripts=`dirname "$0"`
base=$scripts/../..

if [[ `hostname` == 'login0' ]]; then
  # S3IT
  module use /sapps/etc/modules/start/
  module load volta cuda/10.0
else
  # CSD3
  module purge
  module load rhel7/default-peta4
  module load volta cuda/10.0
  module add python-3.6.2-gcc-5.4.0-me5fsee
fi;

mkdir -p $base/venvs

# python3 needs to be installed on your system

virtualenv -p python3 $base/venvs/fairseq3

echo "To activate your environment:"
echo "    source $base/venvs/fairseq3/bin/activate"
