#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $data

# German-English

subdata=$data/de-en

mkdir -p $subdata

wget -N https://files.ifi.uzh.ch/cl/archiv/2019/clcontra/opus_robustness_data_v2.tar.xz -P $subdata

tar -xvf $subdata/opus_robustness_data_v2.tar.xz -C $subdata

mv $subdata/opus_robustness_data/* $subdata/

rm -r $subdata/opus_robustness_data

# sizes
echo "Sizes of de-en corpora:"

for domain in all it koran law medical subtitles; do
    for corpus in train dev test; do
      echo "corpus: "$domain/$corpus
      wc -l $subdata/$domain/$corpus.de $subdata/$domain/$corpus.en
    done
done

# German-Rumansh

subdata=$data/de-rm

mkdir -p $subdata

git clone https://github.com/a-rios/RumantschCorpora $subdata
(cd $subdata && git checkout preprocessed)

tar -xzvf $subdata/preprocessed.tar.gz -C $subdata

mv $subdata/preprocessed/* $subdata

rm -r $subdata/monolingual $subdata/parallel $subdata/scripts $subdata/README.md $subdata/.gitignore $subdata/preprocessed

# take some dev data as standin for training data in blogs domain

mv $subdata/blogs/dev.de $subdata/blogs/train.de
mv $subdata/blogs/dev.rm $subdata/blogs/train.rm

head -n 2000 $subdata/blogs/train.de > $subdata/blogs/dev.de
head -n 2000 $subdata/blogs/train.rm > $subdata/blogs/dev.rm

sed -i -e '1,2000d' $subdata/blogs/train.de
sed -i -e '1,2000d' $subdata/blogs/train.rm

# sizes
echo "Sizes of de-rm corpora:"

for domain in all law blogs; do
    for corpus in train dev test; do
      echo "corpus: "$domain/$corpus
      wc -l $subdata/$domain/$corpus.de $subdata/$domain/$corpus.rm
    done
done

# sanity checks
echo "At this point, please make sure that 1) number of lines are as expected, 2) language suffixes are correct and 3) files are parallel"
