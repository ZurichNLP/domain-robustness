#! /bin/bash

base=/net/cephfs/home/mathmu/scratch/domain-robustness

source $base/venvs/sockeye3/bin/activate
module load volta cuda/9.2

data=$base/data
scripts=$base/scripts
scores=$base/scores

reranked=$base/reranked
mkdir -p $reranked

bleu_reranked=$base/bleu_reranked
mkdir -p $bleu_reranked

# currently, there is only one source language
src=de

# DE-EN

trg=en
bpe_models=" transformer_multilingual_tie2 transformer_reconstruction_tie2"
pieces_models="transformer_multilingual+sentencepiece transformer_reconstruction+sentencepiece"
in_domain="medical"

for corpus in dev test oracle; do

    if [[ $corpus == "dev" ]]; then
        domains=$in_domain
    elif [[ $corpus == "test" ]]; then
        domains="it koran law medical subtitles"
    else
        # oracle
        domains="it koran law subtitles"
        corpus="test"
    fi

    for domain in $domains; do

        data_sub=$data/$src-$trg/$domain

        for weight_combination in "0.00 0.00 1.00"	"0.00 0.10 0.90"	"0.00 0.20 0.80"	"0.00 0.30 0.70"	"0.00 0.40 0.60"	"0.00 0.50 0.50"	"0.00 0.60 0.40"	"0.00 0.70 0.30"	"0.00 0.80 0.20"	"0.00 0.90 0.10"	"0.00 1.00 0.00"	"0.01 0.00 0.99"	"0.01 0.10 0.89"	"0.01 0.20 0.79"	"0.01 0.30 0.69"	"0.01 0.40 0.59"	"0.01 0.50 0.49"	"0.01 0.60 0.39"	"0.01 0.70 0.29"	"0.01 0.80 0.19"	"0.01 0.90 0.09"	"0.02 0.00 0.98"	"0.02 0.10 0.88"	"0.02 0.20 0.78"	"0.02 0.30 0.68"	"0.02 0.40 0.58"	"0.02 0.50 0.48"	"0.02 0.60 0.38"	"0.02 0.70 0.28"	"0.02 0.80 0.18"	"0.02 0.90 0.08"	"0.03 0.00 0.97"	"0.03 0.10 0.87"	"0.03 0.20 0.77"	"0.03 0.30 0.67"	"0.03 0.40 0.57"	"0.03 0.50 0.47"	"0.03 0.60 0.37"	"0.03 0.70 0.27"	"0.03 0.80 0.17"	"0.03 0.90 0.07"	"0.04 0.00 0.96"	"0.04 0.10 0.86"	"0.04 0.20 0.76"	"0.04 0.30 0.66"	"0.04 0.40 0.56"	"0.04 0.50 0.46"	"0.04 0.60 0.36"	"0.04 0.70 0.26"	"0.04 0.80 0.16"	"0.04 0.90 0.06"	"0.05 0.00 0.95"	"0.05 0.10 0.85"	"0.05 0.20 0.75"	"0.05 0.30 0.65"	"0.05 0.40 0.55"	"0.05 0.50 0.45"	"0.05 0.60 0.35"	"0.05 0.70 0.25"	"0.05 0.80 0.15"	"0.05 0.90 0.05"	"0.06 0.00 0.94"	"0.06 0.10 0.84"	"0.06 0.20 0.74"	"0.06 0.30 0.64"	"0.06 0.40 0.54"	"0.06 0.50 0.44"	"0.06 0.60 0.34"	"0.06 0.70 0.24"	"0.06 0.80 0.14"	"0.06 0.90 0.04"	"0.07 0.00 0.93"	"0.07 0.10 0.83"	"0.07 0.20 0.73"	"0.07 0.30 0.63"	"0.07 0.40 0.53"	"0.07 0.50 0.43"	"0.07 0.60 0.33"	"0.07 0.70 0.23"	"0.07 0.80 0.13"	"0.07 0.90 0.03"	"0.08 0.00 0.92"	"0.08 0.10 0.82"	"0.08 0.20 0.72"	"0.08 0.30 0.62"	"0.08 0.40 0.52"	"0.08 0.50 0.42"	"0.08 0.60 0.32"	"0.08 0.70 0.22"	"0.08 0.80 0.12"	"0.08 0.90 0.02"	"0.09 0.00 0.91"	"0.09 0.10 0.81"	"0.09 0.20 0.71"	"0.09 0.30 0.61"	"0.09 0.40 0.51"	"0.09 0.50 0.41"	"0.09 0.60 0.31"	"0.09 0.70 0.21"	"0.09 0.80 0.11"	"0.09 0.90 0.01"	"0.10 0.00 0.90"	"0.10 0.10 0.80"	"0.10 0.20 0.70"	"0.10 0.30 0.60"	"0.10 0.40 0.50"	"0.10 0.50 0.40"	"0.10 0.60 0.30"	"0.10 0.70 0.20"	"0.10 0.80 0.10"	"0.10 0.90 0.00"	"0.20 0.00 0.80"	"0.20 0.10 0.70"	"0.20 0.20 0.60"	"0.20 0.30 0.50"	"0.20 0.40 0.40"	"0.20 0.50 0.30"	"0.20 0.60 0.20"	"0.20 0.70 0.10"	"0.20 0.80 0.00"	"0.30 0.00 0.70"	"0.30 0.10 0.60"	"0.30 0.20 0.50"	"0.30 0.30 0.40"	"0.30 0.40 0.30"	"0.30 0.50 0.20"	"0.30 0.60 0.10"	"0.30 0.70 0.00"	"0.40 0.00 0.60"	"0.40 0.10 0.50"	"0.40 0.20 0.40"	"0.40 0.30 0.30"	"0.40 0.40 0.20"	"0.40 0.50 0.10"	"0.40 0.60 0.00"	"0.50 0.00 0.50"	"0.50 0.10 0.40"	"0.50 0.20 0.30"	"0.50 0.30 0.20"	"0.50 0.40 0.10"	"0.50 0.50 0.00"	"0.60 0.00 0.40"	"0.60 0.10 0.30"	"0.60 0.20 0.20"	"0.60 0.30 0.10"	"0.60 0.40 0.00"	"0.70 0.00 0.30"	"0.70 0.10 0.20"	"0.70 0.20 0.10"	"0.70 0.30 0.00"	"0.80 0.00 0.20"	"0.80 0.10 0.10"	"0.80 0.20 0.00"	"0.90 0.00 0.10"	"0.90 0.10 0.00"	"1.00 0.00 0.00"; do


            for model_prefix in $bpe_models; do

                mode=bpe
                scores_sub=$scores/$src-$trg/$model_prefix

                rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"
                reranked_sub=$reranked/$src-$trg/$model_prefix/$rerank_suffix
                bleu_reranked_sub=$bleu_reranked/$src-$trg/$model_prefix/$rerank_suffix

                mkdir -p $reranked_sub
                mkdir -p $bleu_reranked_sub

                model_name="${model_prefix}_${rerank_suffix}"

                sbatch --cpus-per-task=1 --time=00:01:00 --mem=4G --partition=generic \
                    $scripts/reranking/rerank_multilingual_generic.sh \
                        $base $src $trg $scores_sub $reranked_sub $domain $in_domain $corpus $model_name $model_prefix \
                        $mode $weight_combination $data_sub $bleu_reranked_sub

            done

            for model_prefix in $pieces_models; do

                mode=pieces
                scores_sub=$scores/$src-$trg/$model_prefix

                rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"
                reranked_sub=$reranked/$src-$trg/$model_prefix/$rerank_suffix
                bleu_reranked_sub=$bleu_reranked/$src-$trg/$model_prefix/$rerank_suffix

                mkdir -p $reranked_sub
                mkdir -p $bleu_reranked_sub

                model_name="${model_prefix}_${rerank_suffix}"

                sbatch --cpus-per-task=1 --time=00:01:00 --mem=4G --partition=generic \
                    $scripts/reranking/rerank_multilingual_generic.sh \
                        $base $src $trg $scores_sub $reranked_sub $domain $in_domain $corpus $model_name $model_prefix \
                        $mode $weight_combination $data_sub $bleu_reranked_sub

            done
        done
    done
done


# DE-RM

trg="rm"
bpe_models="transformer_multilingual transformer_reconstruction_tinylr"
pieces_models="transformer_multilingual+sentencepiece transformer_reconstruction+sentencepiece"
in_domain="law"

for corpus in dev test; do

    if [[ $corpus == "dev" ]]; then
        domains=$in_domain
    else
        domains="law blogs"
    fi

    for domain in $domains; do

        data_sub=$data/$src-$trg/$domain

        for weight_combination in "0.00 0.00 1.00"	"0.00 0.10 0.90"	"0.00 0.20 0.80"	"0.00 0.30 0.70"	"0.00 0.40 0.60"	"0.00 0.50 0.50"	"0.00 0.60 0.40"	"0.00 0.70 0.30"	"0.00 0.80 0.20"	"0.00 0.90 0.10"	"0.00 1.00 0.00"	"0.01 0.00 0.99"	"0.01 0.10 0.89"	"0.01 0.20 0.79"	"0.01 0.30 0.69"	"0.01 0.40 0.59"	"0.01 0.50 0.49"	"0.01 0.60 0.39"	"0.01 0.70 0.29"	"0.01 0.80 0.19"	"0.01 0.90 0.09"	"0.02 0.00 0.98"	"0.02 0.10 0.88"	"0.02 0.20 0.78"	"0.02 0.30 0.68"	"0.02 0.40 0.58"	"0.02 0.50 0.48"	"0.02 0.60 0.38"	"0.02 0.70 0.28"	"0.02 0.80 0.18"	"0.02 0.90 0.08"	"0.03 0.00 0.97"	"0.03 0.10 0.87"	"0.03 0.20 0.77"	"0.03 0.30 0.67"	"0.03 0.40 0.57"	"0.03 0.50 0.47"	"0.03 0.60 0.37"	"0.03 0.70 0.27"	"0.03 0.80 0.17"	"0.03 0.90 0.07"	"0.04 0.00 0.96"	"0.04 0.10 0.86"	"0.04 0.20 0.76"	"0.04 0.30 0.66"	"0.04 0.40 0.56"	"0.04 0.50 0.46"	"0.04 0.60 0.36"	"0.04 0.70 0.26"	"0.04 0.80 0.16"	"0.04 0.90 0.06"	"0.05 0.00 0.95"	"0.05 0.10 0.85"	"0.05 0.20 0.75"	"0.05 0.30 0.65"	"0.05 0.40 0.55"	"0.05 0.50 0.45"	"0.05 0.60 0.35"	"0.05 0.70 0.25"	"0.05 0.80 0.15"	"0.05 0.90 0.05"	"0.06 0.00 0.94"	"0.06 0.10 0.84"	"0.06 0.20 0.74"	"0.06 0.30 0.64"	"0.06 0.40 0.54"	"0.06 0.50 0.44"	"0.06 0.60 0.34"	"0.06 0.70 0.24"	"0.06 0.80 0.14"	"0.06 0.90 0.04"	"0.07 0.00 0.93"	"0.07 0.10 0.83"	"0.07 0.20 0.73"	"0.07 0.30 0.63"	"0.07 0.40 0.53"	"0.07 0.50 0.43"	"0.07 0.60 0.33"	"0.07 0.70 0.23"	"0.07 0.80 0.13"	"0.07 0.90 0.03"	"0.08 0.00 0.92"	"0.08 0.10 0.82"	"0.08 0.20 0.72"	"0.08 0.30 0.62"	"0.08 0.40 0.52"	"0.08 0.50 0.42"	"0.08 0.60 0.32"	"0.08 0.70 0.22"	"0.08 0.80 0.12"	"0.08 0.90 0.02"	"0.09 0.00 0.91"	"0.09 0.10 0.81"	"0.09 0.20 0.71"	"0.09 0.30 0.61"	"0.09 0.40 0.51"	"0.09 0.50 0.41"	"0.09 0.60 0.31"	"0.09 0.70 0.21"	"0.09 0.80 0.11"	"0.09 0.90 0.01"	"0.10 0.00 0.90"	"0.10 0.10 0.80"	"0.10 0.20 0.70"	"0.10 0.30 0.60"	"0.10 0.40 0.50"	"0.10 0.50 0.40"	"0.10 0.60 0.30"	"0.10 0.70 0.20"	"0.10 0.80 0.10"	"0.10 0.90 0.00"	"0.20 0.00 0.80"	"0.20 0.10 0.70"	"0.20 0.20 0.60"	"0.20 0.30 0.50"	"0.20 0.40 0.40"	"0.20 0.50 0.30"	"0.20 0.60 0.20"	"0.20 0.70 0.10"	"0.20 0.80 0.00"	"0.30 0.00 0.70"	"0.30 0.10 0.60"	"0.30 0.20 0.50"	"0.30 0.30 0.40"	"0.30 0.40 0.30"	"0.30 0.50 0.20"	"0.30 0.60 0.10"	"0.30 0.70 0.00"	"0.40 0.00 0.60"	"0.40 0.10 0.50"	"0.40 0.20 0.40"	"0.40 0.30 0.30"	"0.40 0.40 0.20"	"0.40 0.50 0.10"	"0.40 0.60 0.00"	"0.50 0.00 0.50"	"0.50 0.10 0.40"	"0.50 0.20 0.30"	"0.50 0.30 0.20"	"0.50 0.40 0.10"	"0.50 0.50 0.00"	"0.60 0.00 0.40"	"0.60 0.10 0.30"	"0.60 0.20 0.20"	"0.60 0.30 0.10"	"0.60 0.40 0.00"	"0.70 0.00 0.30"	"0.70 0.10 0.20"	"0.70 0.20 0.10"	"0.70 0.30 0.00"	"0.80 0.00 0.20"	"0.80 0.10 0.10"	"0.80 0.20 0.00"	"0.90 0.00 0.10"	"0.90 0.10 0.00"	"1.00 0.00 0.00"; do

            for model_prefix in $bpe_models; do

                mode=bpe
                scores_sub=$scores/$src-$trg/$model_prefix

                rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"
                reranked_sub=$reranked/$src-$trg/$model_prefix/$rerank_suffix
                bleu_reranked_sub=$bleu_reranked/$src-$trg/$model_prefix/$rerank_suffix

                mkdir -p $reranked_sub
                mkdir -p $bleu_reranked_sub

                model_name="${model_prefix}_${rerank_suffix}"

                sbatch --cpus-per-task=1 --time=00:01:00 --mem=4G --partition=generic \
                    $scripts/reranking/rerank_multilingual_generic.sh \
                        $base $src $trg $scores_sub $reranked_sub $domain $in_domain $corpus $model_name $model_prefix \
                        $mode $weight_combination $data_sub $bleu_reranked_sub

            done

            for model_prefix in $pieces_models; do

                mode=pieces
                scores_sub=$scores/$src-$trg/$model_prefix

                rerank_suffix="$(echo "${weight_combination}" | tr -d '[:space:]')"
                reranked_sub=$reranked/$src-$trg/$model_prefix/$rerank_suffix
                bleu_reranked_sub=$bleu_reranked/$src-$trg/$model_prefix/$rerank_suffix

                mkdir -p $reranked_sub
                mkdir -p $bleu_reranked_sub

                model_name="${model_prefix}_${rerank_suffix}"

                sbatch --cpus-per-task=1 --time=00:01:00 --mem=4G --partition=generic \
                    $scripts/reranking/rerank_multilingual_generic.sh \
                        $base $src $trg $scores_sub $reranked_sub $domain $in_domain $corpus $model_name $model_prefix \
                        $mode $weight_combination $data_sub $bleu_reranked_sub

            done
        done
    done
done
