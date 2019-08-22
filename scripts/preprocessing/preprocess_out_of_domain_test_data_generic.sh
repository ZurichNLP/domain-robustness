#! /bin/bash

# do not invoke this script directly, but one of scripts/preprocessing/preprocess_{de_en,de_rm}.sh

# more realistic conditions for out-of-domain test sets:
# assume there is no training data for truecasing and BPE models;
# apply the models learned on different data

for domain in $domains; do
    echo "domain: $domain"
    data=$base/data/$src-$trg/$domain

    mkdir -p $data/test_unknown_domain

    for model in all it koran law medical subtitles; do
      if [[ $domain != $model ]]; then

        mkdir -p $data/test_unknown_domain/$model

        echo "Preprocessing test unknown domain; test data: $domain, preprocessing models from: $model"

        $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$model.$src < $data/test.tokenized.$src > $data/test_unknown_domain/$model/test.truecased.$src
        $MOSES/recaser/truecase.perl -model $base/shared_models/truecase-model.$model.$trg < $data/test.tokenized.$trg > $data/test_unknown_domain/$model/test.truecased.$trg

        subword-nmt apply-bpe -c $base/shared_models/$src$trg.$model.bpe --vocabulary $base/shared_models/vocab.$model.$src --vocabulary-threshold $bpe_vocab_threshold < $data/test_unknown_domain/$model/test.truecased.$src > $data/test_unknown_domain/$model/test.bpe.$src
        subword-nmt apply-bpe -c $base/shared_models/$src$trg.$model.bpe --vocabulary $base/shared_models/vocab.$model.$trg --vocabulary-threshold $bpe_vocab_threshold < $data/test_unknown_domain/$model/test.truecased.$trg > $data/test_unknown_domain/$model/test.bpe.$trg

        cat $data/test_unknown_domain/$model/test.bpe.$src | python $scripts/add_tag_to_lines.py --tag "<2$trg>" > $data/test_unknown_domain/$model/test.tag.$src
        cat $data/test_unknown_domain/$model/test.bpe.$trg | python $scripts/add_tag_to_lines.py --tag "<2$src>" > $data/test_unknown_domain/$model/test.tag.$trg

        cat $data/test_unknown_domain/$model/test.truecased.$src | python $scripts/apply_sentencepiece.py --model $shared_models/$src$trg.$model.sentencepiece.model \
          --nbest-size 1 --output-format nbest > $data/test_unknown_domain/$model/test.pieces.$src
        cat $data/test_unknown_domain/$model/test.truecased.$trg | python $scripts/apply_sentencepiece.py --model $shared_models/$src$trg.$model.sentencepiece.model \
          --nbest-size 1 --output-format nbest > $data/test_unknown_domain/$model/test.pieces.$trg

      fi
    done
done

data=$base/data/$src-$trg

# file sizes
for domain in $domains; do
    for model in $domains; do
      if [[ $domain != $model ]]; then

        echo "test data from: $domain, models from: $model"
        wc -l $data/$domain/test_unknown_domain/$model/test.bpe.$src $data/$domain/test_unknown_domain/$model/test.bpe.$trg
        wc -l $data/$domain/test_unknown_domain/$model/test.tag.$src $data/$domain/test_unknown_domain/$model/test.tag.$trg
      fi
    done
done

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"
