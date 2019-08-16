#! /bin/bash

# work around slurm placing scripts in var folder
if [[ $1 == "mode=sbatch" ]]; then
  base=/net/cephfs/home/mathmu/scratch/domain-robustness
else
  script_dir=`dirname "$0"`
  base=$script_dir/..
fi;

mkdir -p $base/shared_models

data=$base/data
scripts=$base/scripts

src=de
trg=en

MOSES=$base/tools/moses-scripts/scripts

bpe_vocab_threshold=10


# more realistic conditions for out-of-domain test sets:
# assume there is no training data for truecasing and BPE models;
# apply the models learned on different data

for domain in all it koran law medical subtitles; do
    echo "domain: $domain"
    data=$base/data/$domain

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
      fi
    done
done

data=$base/data

# file sizes
for domain in all it koran law medical subtitles; do
    for model in all it koran law medical subtitles; do
      if [[ $domain != $model ]]; then

        echo "test data from: $domain, models from: $model"
        wc -l $data/$domain/test_unknown_domain/$model/test.bpe.$src $data/$domain/test_unknown_domain/$model/test.bpe.$trg
        wc -l $data/$domain/test_unknown_domain/$model/test.tag.$src $data/$domain/test_unknown_domain/$model/test.tag.$trg
      fi
    done
done

# sanity checks

echo "At this point, please check that 1) file sizes are as expected, 2) languages are correct and 3) material is still parallel"
