#!/bin/bash
#SBATCH --qos=vesta
#SBATCH --time=168:00:00
#SBATCH --gres gpu:Tesla-V100:4
#SBATCH --cpus-per-task 5
#SBATCH --mem 50g

# THIS MODEL:
# - bilingual reconstruction from translations (not HIDDEN states)
# - fine-tuned from multilingual baseline

module load volta cuda/9.1

scripts=`dirname "$0"`
base=$scripts/..

echo $CUDA_VISIBLE_DEVICES
echo "Done reading visible devices."

export MXNET_ENABLE_GPU_P2P=0
echo "MXNET_ENABLE_GPU_P2P: $MXNET_ENABLE_GPU_P2P"

data=$base/data
models=$base/models
lockdir=$base/lockdir

mkdir -p $models
mkdir -p $lockdir

model_name=reconstruction
init_model_name=multilingual

mkdir -p $models/$model_name

src=de
trg=en

train_source=$data/medical/train.multilingual.$src
train_target=$data/medical/train.multilingual.$trg

dev_source=$data/medical/dev.multilingual.$src
dev_target=$data/medical/dev.multilingual.$trg

# actual training command

python -m sockeye.train \
-s $train_source \
-t $train_target \
-vs $dev_source \
-vt $dev_target \
--output $models/$model_name \
--seed 1 \
--batch-type word \
--batch-size 8192 \
--device-ids -3 \
--decode-and-evaluate-device-id -1 \
--encoder rnn \
--decoder rnn \
--rnn-cell-type lstm \
--rnn-num-hidden 512 \
--rnn-decoder-hidden-dropout 0.2 \
--rnn-dropout-inputs .2:.2 \
--rnn-dropout-states .2:.2 \
--embed-dropout .2:.2 \
--layer-normalization \
--num-layers 2:2 \
--rnn-residual-connections \
--max-seq-len 80:80 \
--weight-tying \
--weight-tying-type src_trg_softmax \
--num-embed 512:512 \
--num-words 50000:50000 \
--optimizer adam \
--initial-learning-rate 0.0001 \
--learning-rate-reduce-num-not-improved 4 \
--checkpoint-frequency 1000 \
--keep-last-params 30 \
--learning-rate-reduce-factor 0.7 \
--decode-and-evaluate 2000 \
--max-num-checkpoint-not-improved 10 \
--min-num-epochs 0 \
--rnn-attention-type mlp \
--gradient-clipping-type abs \
--gradient-clipping-threshold 1 \
--lock-dir $lockdir \
--params $models/$init_model_name \
--allow-missing-params \
--allow-extra-params \
--source-vocab $models/$init_model_name/vocab.json \
--target-vocab $models/$init_model_name/vocab.json \
--reconstruction bilingual \
--reconstruction-loss-weight 0.5 \
--instantiate-hidden st-softmax \
--softmax-temperature 2 \
--gumbel-noise-scale 1.0
