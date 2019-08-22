#! /usr/bin/python3

import argparse
import logging

import sentencepiece as spm

# assuming standard Sockeye vocab files
PAD_ID = 0
UNK_ID = 1
BOS_ID = 2
EOS_ID = 3


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model-prefix", type=str, help="Path where model file should be stored.", required=True)
    parser.add_argument("--input", type=str, help="Path to input text (for instance, truecased).", required=True)
    parser.add_argument("--vocab-size", type=int, help="Desired vocabulary size.", required=True)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    train_args = ["--model_prefix=%s" % args.model_prefix,
                  "--input=%s" % args.input,
                  "--vocab_size=%d" % args.vocab_size,
                  "--character_coverage=1.0",
                  "--model_type=unigram",
                  "--pad_id=%d" % PAD_ID,
                  "--unk_id=%d" % UNK_ID,
                  "--bos_id=%d" % BOS_ID,
                  "--eos_id=%d" % EOS_ID]

    train_args_str = " ".join(train_args)

    spm.SentencePieceTrainer.Train(train_args_str)


if __name__ == '__main__':
    main()
