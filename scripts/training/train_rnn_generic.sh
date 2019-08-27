#!/bin/bash
#SBATCH --qos=vesta
#SBATCH --time=168:00:00
#SBATCH --gres gpu:Tesla-V100:4
#SBATCH --cpus-per-task 5
#SBATCH --mem 50g

echo $CUDA_VISIBLE_DEVICES
echo "Done reading visible devices."

export MXNET_ENABLE_GPU_P2P=0
echo "MXNET_ENABLE_GPU_P2P: $MXNET_ENABLE_GPU_P2P"

python -m sockeye.train \
-s $train_source \
-t $train_target \
-vs $dev_source \
-vt $dev_target \
--output $models/$model_name \
--seed 1 \
--batch-type word \
--batch-size 4096 \
--device-ids 0 1 2 \
--decode-and-evaluate-device-id 3 \
--encoder rnn \
--decoder rnn \
--rnn-cell-type lstm \
--rnn-num-hidden 512 \
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
--initial-learning-rate 0.001 \
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
--disable-device-locking