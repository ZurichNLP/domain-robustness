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
--encoder transformer \
--decoder transformer \
--num-layers 6:6 \
--transformer-model-size 512 \
--transformer-attention-heads 8 \
--transformer-feed-forward-num-hidden 2048 \
--transformer-preprocess n \
--transformer-postprocess dr \
--transformer-dropout-attention 0.2 \
--transformer-dropout-act 0.2 \
--transformer-dropout-prepost 0.2 \
--transformer-positional-embedding-type fixed \
--embed-dropout .2:.2 \
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
--gradient-clipping-type abs \
--gradient-clipping-threshold 1 \
--disable-device-locking \
--sentencepiece \
--sentencepiece-nbest 64 \
--sentencepiece-alpha 0.1 \
--sentencepiece-model $sentencepiece_model \
--source-vocab $source_vocab \
--target-vocab $target_vocab
