#! /bin/bash

script_dir=`dirname "$0"`
base=$script_dir/../..
scripts=$base/scripts

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_de_rm.sh

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_multilingual_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_multilingual_de_rm.sh

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_reconstruction_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_rnn_reconstruction_de_rm.sh

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_de_rm.sh

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_multilingual_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_multilingual_de_rm.sh

$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_reconstruction_de_en.sh
$scripts/wrap-slurm-gpu-training-task.sh $scripts/training/train_transformer_reconstruction_de_rm.sh
