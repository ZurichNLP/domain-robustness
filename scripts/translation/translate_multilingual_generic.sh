#! /bin/bash

data=$base/data
scripts=$base/scripts

translations=$base/translations
mkdir -p $translations

translations=$base/translations/$src-$trg
mkdir -p $translations

mkdir -p $translations/$model_name

MOSES=$base/tools/moses-scripts/scripts

num_threads=10

for domain in $domains; do

    if [[ $domain != $in_domain ]]; then
      data=$base/data/$domain/test_unknown_domain/$in_domain
    else
      data=$base/data/$domain
    fi

    OMP_NUM_THREADS=$num_threads python -m sockeye.translate \
            -i $data/test.bpe.tag.$src \
            -o $translations/$model_name/test.bpe.tag.$model_name.$domain.$trg \
            -m $base/models/$model_name \
            --beam-size 10 \
            --length-penalty-alpha 1.0 \
            --device-ids 0 \
            --batch-size 100 \
            --disable-device-locking

    # remove target language tag

    cat $translations/$model_name/test.bpe.tag.$model_name.$domain.$trg | python $scripts/remove_tag_from_translations.py --tag "<2$src>" > $translations/$model_name/test.bpe.$model_name.$domain.$trg

    # undo BPE

    cat $translations/$model_name/test.bpe.$model_name.$domain.$trg | sed -r 's/@@( |$)//g' > $translations/$model_name/test.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $translations/$model_name/test.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $translations/$model_name/test.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $translations/$model_name/test.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $translations/$model_name/test.$model_name.$domain.$trg

done