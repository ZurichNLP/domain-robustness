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

    $MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$src -model $base/shared_models/$src$trg.truecase-model.$domain.$src
    $MOSES/recaser/train-truecaser.perl -corpus $data/train.tokenized.clean.$trg -model $base/shared_models/$src$trg.truecase-model.$domain.$trg

    # apply truecase model to train, test and dev

    for corpus in train; do
      $MOSES/recaser/truecase.perl -model $base/shared_models/$src$trg.truecase-model.$domain.$src < $data/$corpus.tokenized.clean.$src > $data/$corpus.truecased.$src
      $MOSES/recaser/truecase.perl -model $base/shared_models/$src$trg.truecase-model.$domain.$trg < $data/$corpus.tokenized.clean.$trg > $data/$corpus.truecased.$trg
    done

    for corpus in dev test; do
      $MOSES/recaser/truecase.perl -model $base/shared_models/$src$trg.truecase-model.$domain.$src < $data/$corpus.tokenized.$src > $data/$corpus.truecased.$src
      $MOSES/recaser/truecase.perl -model $base/shared_models/$src$trg.truecase-model.$domain.$trg < $data/$corpus.tokenized.$trg > $data/$corpus.truecased.$trg
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

    # create a version of BPE files with a language tags on both sides for multilingual models

    for corpus in train dev test; do
      cat $data/$corpus.bpe.$src | python $scripts/add_tag_to_lines.py --tag "<2$trg>" > $data/$corpus.bpe.tag.$src
      cat $data/$corpus.bpe.$trg | python $scripts/add_tag_to_lines.py --tag "<2$src>" > $data/$corpus.bpe.tag.$trg
    done

    # concatenate final training data for multilingual models (only for train and dev)

    for corpus in train dev; do
      cat $data/$corpus.bpe.tag.$src $data/$corpus.bpe.tag.$trg > $data/$corpus.bpe.multilingual.$src
      cat $data/$corpus.bpe.tag.$trg $data/$corpus.bpe.tag.$src > $data/$corpus.bpe.multilingual.$trg
    done

    # create a version of truecased files with a language tags on both sides for multilingual models WITH SENTENCEPIECE

    for corpus in train dev test; do
      cat $data/$corpus.truecased.$src | python $scripts/add_tag_to_lines.py --tag "<2$trg>" > $data/$corpus.truecased.tag.$src
      cat $data/$corpus.truecased.$trg | python $scripts/add_tag_to_lines.py --tag "<2$src>" > $data/$corpus.truecased.tag.$trg
    done

    # concatenate final training data for multilingual models WITH SENTENCEPIECE (only for train and dev)

    for corpus in train dev; do
      cat $data/$corpus.truecased.tag.$src $data/$corpus.truecased.tag.$trg > $data/$corpus.truecased.multilingual.$src
      cat $data/$corpus.truecased.tag.$trg $data/$corpus.truecased.tag.$src > $data/$corpus.truecased.multilingual.$trg
    done

    # train sentencepiece model

    cat $data/train.truecased.$src $data/train.truecased.$trg > $data/train.truecased.both
    python $scripts/train_sentencepiece.py --model-prefix $shared_models/$src$trg.$domain.sentencepiece --input $data/train.truecased.both --vocab-size $sentencepiece_vocab_size

    # convert sentencepiece vocab

    cat $shared_models/$src$trg.$domain.sentencepiece.vocab | python $scripts/convert_sentencepiece_to_sockeye_vocab.py > $shared_models/$src$trg.$domain.sentencepiece.sockeye.vocab

    # convert sentencepiece vocab and add language tags for multilingual

    cat $shared_models/$src$trg.$domain.sentencepiece.vocab | python $scripts/convert_sentencepiece_to_sockeye_vocab.py --add "<2$trg>" "<2$src>" > $shared_models/$src$trg.$domain.sentencepiece.multilingual.sockeye.vocab

    # apply deterministic (best) sentencepiece segmentation to truecased train, dev and test data

    for corpus in train dev test; do
      cat $data/$corpus.truecased.$src | python $scripts/apply_sentencepiece.py --model $shared_models/$src$trg.$domain.sentencepiece.model \
        --nbest-size 1 --output-format nbest > $data/$corpus.pieces.$src
      cat $data/$corpus.truecased.$trg | python $scripts/apply_sentencepiece.py --model $shared_models/$src$trg.$domain.sentencepiece.model \
        --nbest-size 1 --output-format nbest > $data/$corpus.pieces.$trg
    done

    # add tag to best pieces segmentation of data for multilingual models WITH SENTENCEPIECE AND DISTILLATION

    for corpus in train dev test; do
      cat $data/$corpus.pieces.$src | python $scripts/add_tag_to_lines.py --tag "<2$trg>" > $data/$corpus.pieces.tag.$src
      cat $data/$corpus.pieces.$trg | python $scripts/add_tag_to_lines.py --tag "<2$src>" > $data/$corpus.pieces.tag.$trg
    done

    # concatenate final training data for multilingual models WITH SENTENCEPIECE AND DISTILLATION (only for train and dev)

    for corpus in train dev; do
      cat $data/$corpus.pieces.tag.$src $data/$corpus.pieces.tag.$trg > $data/$corpus.pieces.multilingual.$src
      cat $data/$corpus.pieces.tag.$trg $data/$corpus.pieces.tag.$src > $data/$corpus.pieces.multilingual.$trg
    done

done

data=$base/data/$src-$trg

# file sizes
for domain in $domains; do
    for corpus in train dev test; do
      echo "corpus: "$corpus
      wc -l $data/$domain/$corpus.*
    done

    wc -l $shared_models/$src$trg.$domain.sentencepiece.vocab $shared_models/$src$trg.$domain.sentencepiece.sockeye.vocab

done

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"
