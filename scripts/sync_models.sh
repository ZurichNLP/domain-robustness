#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data
models=$base/models

rsync -avzP $models mathmu@login0.s3it.uzh.ch:/net/cephfs/home/mathmu/scratch/domain-robustness/
