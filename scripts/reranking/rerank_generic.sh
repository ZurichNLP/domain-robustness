#! /bin/bash

scripts=$base/scripts

scores=$base/scores/$src-$trg

reranked=$base/reranked
mkdir -p $reranked

reranked=$base/reranked/$src-$trg
mkdir -p $reranked

mkdir -p $reranked/$model_prefix

mkdir -p $reranked/$model_prefix/$rerank_suffix

MOSES=$base/tools/moses-scripts/scripts

if [[ $corpus == 'dev' ]]; then
    domains=$in_domain
    scores=$base/scores_dev/$src-$trg
fi

for domain in $domains; do

    # rerank nbest translations

    python $scripts/rerank_nbest.py --nbest $scores/$model_prefix/$corpus.all_scores.$model_prefix.$domain.$trg \
            --scores "scores_lm" "scores_tm_forward" \
            --weights $weight_combination \
            > $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_nbest.$model_name.$domain.$trg

    # extract top 1 after reranking

    cat $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 1 > $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.bpe.$model_name.$domain.$trg

    # undo BPE

    cat $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.bpe.$model_name.$domain.$trg | sed -r 's/@@( |$)//g' > $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $reranked/$model_prefix/$rerank_suffix/$corpus.reranked_best.$model_name.$domain.$trg

done
