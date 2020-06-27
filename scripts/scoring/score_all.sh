#! /bin/bash

base=/net/cephfs/home/mathmu/scratch/domain-robustness

source $base/venvs/fairseq3/bin/activate
module load volta cuda/9.2

data=$base/data
scripts=$base/scripts
models=$base/models
models_lm=$base/models_lm
translations=$base/translations

scores=$base/scores
mkdir -p $scores

# currently, there is only one source language
src=de

# DE-EN

trg=en
bpe_models=" transformer_multilingual_tie2 transformer_reconstruction_tie2"
pieces_models="transformer_multilingual+sentencepiece transformer_reconstruction+sentencepiece"
in_domain="medical"

for corpus in dev test; do

    if [[ $corpus == "dev" ]]; then
        domains="medical"
    else
        domains="it koran law medical subtitles"
    fi

    for domain in $domains; do

        if [[ $domain != $in_domain ]]; then
          data_sub=$data/$src-$trg/$domain/test_unknown_domain/$in_domain
        else
          data_sub=$data/$src-$trg/$domain
        fi

        for model_name in $bpe_models; do

            mode=bpe

            models_sub=$models/$src-$trg/$model_name
            models_lm_sub=$models_lm/$src-$trg/$mode
            translations_sub=$translations/$src-$trg/$model_name

            scores_sub=$scores/$src-$trg/$model_name

            if [[ -d $scores_sub ]]; then
                echo "scores_sub exists: $scores_sub"
                echo "Skipping."
                continue
            fi

            mkdir -p $scores_sub

            sbatch --qos=vesta --time=12:00:00 --gres gpu:Tesla-V100-32GB:1 --cpus-per-task 1 --mem 16g \
                $scripts/scoring/score_all_generic.sh \
                    $base $data_sub $translations_sub $scores_sub $src $trg \
                    $domain $corpus $mode $models_sub $models_lm_sub $model_name

            exit # TODO: remove
        done

        for model_name in $pieces_models; do

            mode=pieces

            models_sub=$models/$src-$trg/$model_name
            models_lm_sub=$models_lm/$src-$trg/$mode
            translations_sub=$translations/$src-$trg/$model_name

            scores_sub=$scores/$src-$trg/$model_name

            if [[ -d $scores_sub ]]; then
                echo "scores_sub exists: $scores_sub"
                echo "Skipping."
                continue
            fi

            mkdir -p $scores_sub

            sbatch --qos=vesta --time=12:00:00 --gres gpu:Tesla-V100-32GB:1 --cpus-per-task 1 --mem 16g \
                $scripts/scoring/score_all_generic.sh \
                    $base $data_sub $translations_sub $scores_sub $src $trg \
                    $domain $corpus $mode $models_sub $models_lm_sub $model_name
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
        domains="law"
    else
        domains="law blogs"
    fi

    for domain in $domains; do

        if [[ $domain != $in_domain ]]; then
          data_sub=$data/$src-$trg/$domain/test_unknown_domain/$in_domain
        else
          data_sub=$data/$src-$trg/$domain
        fi

        for model_name in $bpe_models; do

            mode=bpe

            models_sub=$models/$src-$trg/$model_name
            models_lm_sub=$models_lm/$src-$trg/$mode
            translations_sub=$translations/$src-$trg/$model_name

            scores_sub=$scores/$src-$trg/$model_name

            if [[ -d $scores_sub ]]; then
                echo "scores_sub exists: $scores_sub"
                echo "Skipping."
                continue
            fi

            mkdir -p $scores_sub

            sbatch --qos=vesta --time=12:00:00 --gres gpu:Tesla-V100-32GB:1 --cpus-per-task 1 --mem 16g \
                $scripts/scoring/score_all_generic.sh \
                    $base $data_sub $translations_sub $scores_sub $src $trg \
                    $domain $corpus $mode $models_sub $models_lm_sub $model_name
        done

        for model_name in $pieces_models; do

            mode=pieces

            models_sub=$models/$src-$trg/$model_name
            models_lm_sub=$models_lm/$src-$trg/$mode
            translations_sub=$translations/$src-$trg/$model_name

            scores_sub=$scores/$src-$trg/$model_name

            if [[ -d $scores_sub ]]; then
                echo "scores_sub exists: $scores_sub"
                echo "Skipping."
                continue
            fi

            mkdir -p $scores_sub

            sbatch --qos=vesta --time=12:00:00 --gres gpu:Tesla-V100-32GB:1 --cpus-per-task 1 --mem 16g \
                $scripts/scoring/score_all_generic.sh \
                    $base $data_sub $translations_sub $scores_sub $src $trg \
                    $domain $corpus $mode $models_sub $models_lm_sub $model_name
        done

    done
done
