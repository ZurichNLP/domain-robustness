#! /bin/bash

scripts=$base/scripts

scores=$base/scores

reranked=$base/reranked
mkdir -p $reranked

reranked=$base/reranked/$src-$trg
mkdir -p $reranked

mkdir -p $reranked/$model_name

MOSES=$base/tools/moses-scripts/scripts

for domain in $domains; do

    # rerank nbest translations

    python $scripts/rerank_nbest.py --nbest $scores/$model_prefix/test.all_scores.$model_name.$domain.$trg \
            --scores "scores_lm" "scores_tm_forward" \
            --weights $weight_combination \
            > $reranked/$model_name/test.reranked_nbest.$model_name.$domain.$trg

    # extract top 1 after reranking

    cat $reranked/$model_name/test.reranked_nbest.$model_name.$domain.$trg | python $scripts/extract_top_translations_from_nbest.py --top 1 > $reranked/$model_name/test.reranked_best.bpe.$model_name.$domain.$trg

    # undo BPE

    cat $reranked/$model_name/test.reranked_best.bpe.$model_name.$domain.$trg | sed -r 's/@@( |$)//g' > $reranked/$model_name/test.reranked_best.truecased.$model_name.$domain.$trg

    # undo truecasing

    cat $reranked/$model_name/test.reranked_best.truecased.$model_name.$domain.$trg | $MOSES/recaser/detruecase.perl > $reranked/$model_name/test.reranked_best.tokenized.$model_name.$domain.$trg

    # undo tokenization

    cat $reranked/$model_name/test.reranked_best.tokenized.$model_name.$domain.$trg | $MOSES/tokenizer/detokenizer.perl -l $trg > $reranked/$model_name/test.reranked_best.$model_name.$domain.$trg

done
