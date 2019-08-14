#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

tools=$base/tools
mkdir -p $tools

echo "Make sure this script is executed AFTER you have activated a virtualenv"

# install Sockeye

git clone https://github.com/bricksdont/sockeye $tools/sockeye
(cd $tools/sockeye && git checkout reconstruction_niu)
(cd $tools/sockeye && git pull)

pip install --upgrade --no-deps $tools/sockeye