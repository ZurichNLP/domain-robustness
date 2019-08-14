#! /bin/bash

# virtualenv must be installed on your system, install with e.g.
# pip install virtualenv

scripts=`dirname "$0"`
base=$scripts/..

mkdir -p $base/venvs

# python3 needs to be installed on your system

virtualenv -p python3 $base/venvs/sockeye3

echo "To activate your environment:"
echo "    source $base/venvs/sockeye3/bin/activate"
