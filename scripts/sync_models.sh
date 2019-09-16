#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
models=$base/models

rsync -a $data /home/cluster/mathmu/data/domain_robustness/
rsync -a $models /home/cluster/mathmu/data/domain_robustness/
