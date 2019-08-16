#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
models=$base/models

rsync -r $data /home/cluster/mathmu/data/domain_robustness/
rsync -r $models /home/cluster/mathmu/data/domain_robustness/
