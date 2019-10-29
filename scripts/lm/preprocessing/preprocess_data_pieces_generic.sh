#! /bin/bash

# cannot be called directly, needs to be invoked!

data=$base/data

train_path=$data/$src-$trg/$in_domain/train.pieces.$trg
dev_path=$data/$src-$trg/$in_domain/dev.pieces.$trg
test_path=$data/$src-$trg/$in_domain/test.pieces.$trg

preprocessed_data=$data/$src-$trg/fairseq-preprocessed-pieces

mkdir -p $preprocessed_data

num_workers=2

fairseq-preprocess \
     --only-source \
     --trainpref $train_path \
     --validpref $dev_path \
     --testpref $test_path \
     --destdir $preprocessed_data \
     --workers $num_workers
