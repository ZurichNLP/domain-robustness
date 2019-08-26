#! /usr/bin/python3

import sys
import argparse
import logging

import sentencepiece as spm


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model", type=str, help="Path where model file is stored.", required=True)

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
        pieces = line.split(" ")

        line = sp.DecodePieces(pieces)

        print(line)


if __name__ == '__main__':
    main()
