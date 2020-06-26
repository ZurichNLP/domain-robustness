#! /bin/bash

# calling script needs to set:

# $preprocessed_lm_sub
# $models_lm_sub

preprocessed_lm_sub=$1
models_lm_sub=$2

log_file=$models_lm_sub/log

fairseq-train --task language_modeling \
    $preprocessed_lm_sub \
    --save-dir $models_lm_sub \
    --arch transformer_lm \
    --share-decoder-input-output-embed \
    --dropout 0.1 \
    --max-update 100000 \
    --lr-scheduler inverse_sqrt \
    --warmup-updates 4000 \
    --warmup-init-lr 1e-07 \
    --optimizer adam \
    --adam-betas '(0.9, 0.98)' \
    --lr 0.0005 \
    --weight-decay 0.01 \
    --clip-norm 0.0 \
    --criterion label_smoothed_cross_entropy \
    --max-tokens 1024 \
    --update-freq 16 \
    --tokens-per-sample 512 \
    --seed 1 \
    --sample-break-mode none \
    --skip-invalid-size-inputs-valid-test \
    --ddp-backend=no_c10d  2>&1 | tee -a $log_file

# copy dict as a workaround, since fairseq looks for it in the wrong place

cp $preprocessed_lm_sub/dict.txt $models_lm_sub/
