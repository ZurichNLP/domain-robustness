#! /bin/bash

# calling script needs to set:
# $base
# $src
# $trg
# $scores_sub
# $reranked_sub
# $domain
# $in_domain
# $corpus
# $model_name
# $model_prefix
# $mode
# $weight_combination
# $data_sub
# $bleu_reranked_sub

base=$1
src=$2
trg=$3
scores_sub=$4
reranked_sub=$5
domain=$6
in_domain=$7
corpus=$8
model_name=$9
model_prefix=${10}
mode=${11}
weight_combination=${12}
data_sub=${13}
bleu_reranked_sub=${14}

scripts=$base/scripts

MOSES=$base/tools/moses-scripts/scripts

# rerank nbest translations

python $scripts/rerank_nbest.py --nbest $scores_sub/$corpus.all_scores.$model_prefix.$domain.$trg \
        --scores "scores_lm" "scores_tm_forward" "scores_tm_backward" \
        --weights $weight_combination \
        > $reranked_sub/$corpus.reranked_nbest.$model_name.$domain.$trg

# extract top 1 after reranking

cat $reranked_sub/$corpus.reranked_nbest.$model_name.$domain.$trg | \
    python $scripts/extract_top_translations_from_nbest.py --top 1 > \
        $reranked_sub/$corpus.reranked_best.$mode.tag.$model_name.$domain.$trg

# remove target language tag

cat $reranked_sub/$corpus.reranked_best.$mode.tag.$model_name.$domain.$trg | \
    python $scripts/remove_tag_from_translations.py --src-tag "<2$src>" --trg-tag "<2$trg>" > \
        $reranked_sub/$corpus.reranked_best.$mode.$model_name.$domain.$trg

# undo BPE / pieces

if [[ $mode == "bpe" ]]; then
    cat $reranked_sub/$corpus.reranked_best.$mode.$model_name.$domain.$trg | sed -r 's/@@( |$)//g' > \
        $reranked_sub/$corpus.reranked_best.truecased.$model_name.$domain.$trg
else
    cat $reranked_sub/$corpus.reranked_best.$mode.$model_name.$domain.$trg | \
        python $scripts/remove_sentencepiece.py --model $base/shared_models/$src$trg.$in_domain.sentencepiece.model > \
            $reranked_sub/$corpus.reranked_best.truecased.$model_name.$domain.$trg
fi

# undo truecasing

cat $reranked_sub/$corpus.reranked_best.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > \
    $reranked_sub/$corpus.reranked_best.tokenized.$model_name.$domain.$trg

# undo tokenization

cat $reranked_sub/$corpus.reranked_best.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > \
    $reranked_sub/$corpus.reranked_best.$model_name.$domain.$trg

# evaluate this combination

. $scripts/evaluation/evaluate_reranked_generic.sh \
    $data_sub $bleu_reranked_sub $reranked_sub $model_name $domain $corpus $trg
