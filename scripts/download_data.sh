#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $data

wget https://files.ifi.uzh.ch/cl/archiv/2019/clcontra/opus_robustness_data.tar.xz -P $data

tar -xJfv $data/opus_robustness_data.tar.xz -C $data
