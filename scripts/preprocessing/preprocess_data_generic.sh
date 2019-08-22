#! /bin/bash

# do not invoke this script directly, but one of scripts/preprocessing/preprocess_{de_en,de_rm}.sh

for domain in $domains; do
    echo "domain: $domain"
    data=$base/data/$src-$trg/$domain

    # normalize train, dev and test

    for corpus in train dev test; do
      cat $data/$corpus.$src | perl $MOSES/tokenizer/normalize-punctuation.perl > $data/$corpus.normalized.$src
      cat $data/$corpus.$trg | perl $MOSES/tokenizer/normalize-punctuation.perl > $data/$corpus.normalized.$trg
    done

    # tokenize train, dev and test

    for corpus in train dev test; do
      cat $data/$corpus.normalized.$src | perl $MOSES/tokenizer/tokenizer.perl -a -q -l $src > $data/$corpus.tokenized.$src
      cat $data/$corpus.normalized.$trg | perl $MOSES/tokenizer/tokenizer.perl -a -q -l $trg > $data/$corpus.tokenized.$trg
    done

    # clean length and ratio of train (only train!)

    $MOSES/training/clean-corpus-n.perl $data/train.tokenized $src $trg $data/train.tokenized.clean 1 80

    # learn truecase model on train (learn one model for each language)

    $MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$src -model $base/shared_models/truecase-model.$domain.$src
    $MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$trg -model $base/shared_models/truecase-model.$domain.$trg

    # apply truecase model to train, test and dev

    for corpus in train; do
      $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$domain.$src < $data/$corpus.tokenized.clean.$src > $data/$corpus.truecased.$src
      $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$domain.$trg < $data/$corpus.tokenized.clean.$trg > $data/$corpus.truecased.$trg
    done

    for corpus in dev test; do
      $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$domain.$src < $data/$corpus.tokenized.$src > $data/$corpus.truecased.$src
      $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$domain.$trg < $data/$corpus.tokenized.$trg > $data/$corpus.truecased.$trg
    done

    # learn BPE model on train (concatenate both languages)

    subword-nmt learn-joint-bpe-and-vocab -i $data/train.truecased.$src $data/train.truecased.$trg \
      --write-vocabulary $base/shared_models/vocab.$domain.$src $base/shared_models/vocab.$domain.$trg \
      -s $bpe_num_operations -o $base/shared_models/$src$trg.$domain.bpe

    # apply BPE model to train, test and dev

    for corpus in train dev test; do
      subword-nmt apply-bpe -c $base/shared_models/$src$trg.$domain.bpe --vocabulary $base/shared_models/vocab.$domain.$src --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.truecased.$src > $data/$corpus.bpe.$src
      subword-nmt apply-bpe -c $base/shared_models/$src$trg.$domain.bpe --vocabulary $base/shared_models/vocab.$domain.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/$corpus.truecased.$trg > $data/$corpus.bpe.$trg
    done

    # create a version of BPE files with a language tags on both sides for reconstruction models

    for corpus in train dev test; do
      cat $data/$corpus.bpe.$src | python $scripts/add_tag_to_lines.py --tag "<2$trg>" > $data/$corpus.tag.$src
      cat $data/$corpus.bpe.$trg | python $scripts/add_tag_to_lines.py --tag "<2$src>" > $data/$corpus.tag.$trg
    done

    # concatenate final training data for reconstruction models (only for train and dev)

    for corpus in train dev; do
      cat $data/$corpus.tag.$src $data/$corpus.tag.$trg > $data/$corpus.multilingual.$src
      cat $data/$corpus.tag.$trg $data/$corpus.tag.$src > $data/$corpus.multilingual.$trg
    done

    # train sentencepiece model

    cat $data/$corpus.truecased.$src $data/train.truecased.$trg > $data/train.truecased.both
    python $scripts/train_sentencepiece.py --model-prefix $shared_models/$src$trg.$domain.sentencepiece --input $data/train.truecased.both --vocab-size $sentencepiece_vocab_size

    # convert sentencepiece vocab

    cat $shared_models/$src$trg.$domain.sentencepiece.vocab | python $scripts/convert_sentencepiece_to_sockeye_vocab.py > $shared_models/$src$trg.$domain.sentencepiece.sockeye.vocab

done

data=$base/data/$src-$trg

# file sizes
for domain in $domains; do
    for corpus in train dev test; do
      echo "corpus: "$corpus
      wc -l $data/$domain/$corpus.bpe.$src $data/$domain/$corpus.bpe.$trg
      wc -l $data/$domain/$corpus.tag.$src $data/$domain/$corpus.tag.$trg

      # there is no multilingual test data
      if [[ $corpus != "test" ]]; then
        wc -l $data/$domain/$corpus.multilingual.$src $data/$domain/$corpus.multilingual.$trg
      fi
    done

    wc -l $shared_models/$src$trg.$domain.sentencepiece.vocab $shared_models/$src$trg.$domain.sentencepiece.sockeye.vocab

done

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"
