#! /bin/bash

# calling process needs to set:
# $base
# $data_sub
# $translations_sub
# $scores_sub
# $src
# $trg
# $domain
# $corpus
# $mode
# $models_sub
# $models_lm_sub
# $model_name

base=$1
data_sub=$2
translations_sub=$3
scores_sub=$4
src=$5
trg=$6
domain=$7
corpus=$8
mode=$9
models_sub=${10}
models_lm_sub=${11}
model_name=${12}

venvs=$base/venvs
scripts=$base/scripts

score_type="neglogprob"

# extract translations from JSON objects

cat $translations_sub/$corpus.nbest.$model_name.$domain.$trg | \
    python $scripts/extract_top_translations_from_nbest.py --top 50 > \
        $scores_sub/$corpus.nbest.$model_name.$domain.$trg

# for source, repeat each line as many times as size of nbest list

cat $data_sub/$corpus.$mode.tag.$src | perl -ne 'print $_ x 50' > $scores_sub/$corpus.nbest.$model_name.$domain.$src

# remove tags for LM scoring

cat $scores_sub/$corpus.nbest.$model_name.$domain.$trg | \
   python $scripts/remove_tag_from_translations.py --src-tag "<2$src>" --trg-tag "<2$trg>" \
      > $scores_sub/$corpus.nbest_no_tags.$model_name.$domain.$trg

# fairseq LM scoring of target side

# activate fairseq3 venv

source $venvs/fairseq3/bin/activate

input=$scores_sub/$corpus.nbest_no_tags.$model_name.$domain.$trg
output=$scores_sub/$corpus.lm.$model_name.$domain.scores
model_path=$models_lm_sub

. $scripts/lm/score_lm_generic.sh $input $output $model_path $score_type $scripts

# Sockeye scoring

# re-activate sockeye venv

source $venvs/sockeye3/bin/activate

batch_size=512
model_path=$models_sub
max_seq_len=256

# forward scoring

input_src=$scores_sub/$corpus.nbest.$model_name.$domain.$src
input_trg=$scores_sub/$corpus.nbest.$model_name.$domain.$trg
output=$scores_sub/$corpus.tm_forward.$model_name.$domain.scores

. $scripts/scoring/score_tm_generic.sh $input_src $input_trg $output $batch_size $model_path $max_seq_len

# backward scoring

input_src=$scores_sub/$corpus.nbest.$model_name.$domain.$trg
input_trg=$scores_sub/$corpus.nbest.$model_name.$domain.$src
output=$scores_sub/$corpus.tm_backward.$model_name.$domain.scores

. $scripts/scoring/score_tm_generic.sh $input_src $input_trg $output $batch_size $model_path $max_seq_len

# add all scores to nbest JSON

python $scripts/add_scores_to_nbest.py \
    --nbest $translations_sub/$corpus.nbest.$model_name.$domain.$trg \
    --scores $scores_sub/$corpus.lm.$model_name.$domain.scores \
             $scores_sub/$corpus.tm_forward.$model_name.$domain.scores \
             $scores_sub/$corpus.tm_backward.$model_name.$domain.scores \
    --names "scores_lm" "scores_tm_forward" "scores_tm_backward" \
    > $scores_sub/$corpus.all_scores.$model_name.$domain.$trg
