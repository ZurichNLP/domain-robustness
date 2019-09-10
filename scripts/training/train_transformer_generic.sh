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

# parameters are the same for all Transformer models

batch_size="512"
num_embed="512:512"
num_layers="6:6"
transformer_model_size="512"
transformer_attention_heads="8"
transformer_feed_forward_num_hidden="2048"

python -m sockeye.train \
-s $train_source \
-t $train_target \
-vs $dev_source \
-vt $dev_target \
--output $models/$model_name \
--seed 1 \
--batch-type word \
--batch-size $batch_size \
--device-ids 0 \
--decode-and-evaluate-device-id 0 \
--encoder transformer \
--decoder transformer \
--num-layers $num_layers \
--transformer-model-size $transformer_model_size \
--transformer-attention-heads $transformer_attention_heads \
--transformer-feed-forward-num-hidden $transformer_feed_forward_num_hidden \
--transformer-preprocess n \
--transformer-postprocess dr \
--transformer-dropout-attention 0.2 \
--transformer-dropout-act 0.2 \
--transformer-dropout-prepost 0.2 \
--transformer-positional-embedding-type fixed \
--embed-dropout .2:.2 \
--weight-tying \
--weight-tying-type src_trg_softmax \
--num-embed $num_embed \
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
--gradient-clipping-type abs \
--gradient-clipping-threshold 1 \
--disable-device-locking \
--update-interval 8
