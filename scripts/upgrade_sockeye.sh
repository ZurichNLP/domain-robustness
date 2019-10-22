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

# work around .git issue on lustre file systems
mv $tools/sockeye/.git $tools/.git

pip install --upgrade --no-deps $tools/sockeye

# work around .git issue on lustre file systems
mv $tools/.git $tools/sockeye/.git
