#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $data

wget -N https://files.ifi.uzh.ch/cl/archiv/2019/clcontra/opus_robustness_data.tar.xz -P $data

tar -xvf $data/opus_robustness_data.tar.xz -C $data

mv $data/opus_robustness_data/* $data/

rm -r $data/opus_robustness_data

# sizes
echo "Sizes of corpora:"

for domain in all it koran law medical subtitles; do
    for corpus in train dev test; do
      echo "corpus: "$domain/$corpus
      wc -l $data/$domain/$corpus.de $data/$domain/$corpus.en
    done
done

# sanity checks
echo "At this point, please make sure that 1) number of lines are as expected, 2) language suffixes are correct and 3) files are parallel"
