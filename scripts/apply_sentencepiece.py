#! /usr/bin/python3

import sys
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

    parser.add_argument("--model", type=str, help="Path where model file is stored.", required=True)
    parser.add_argument("--nbest-size", type=int, help="Size of nbest list for piece sampling.", default=64)
    parser.add_argument("--alpha", type=float, help="Sampling alpha parameter.", default=0.1)
    parser.add_argument("--output-format", type=str, help="Whether to sample or output most likely segmentation.", required=True, choices=["sample", "nbest"])

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    sp = spm.SentencePieceProcessor()
    sp.Load(args.model)

    for line in sys.stdin:
        line = line.strip()

        if args.output_format == "sample":
            pieces = sp.SampleEncodeAsPieces(input=line, nbest_size=args.nbest_size, alpha=args.alpha)
        elif args.output_format == "nbest":
            pieces = sp.NBestEncodeAsPieces(input=line, nbest_size=args.nbest_size)
        else:
            logging.error("Unknown output format for sentencepiece.")
            sys.exit(0)

        pieces_line = " ".join(pieces)
        print(pieces_line)


if __name__ == '__main__':
    main()
