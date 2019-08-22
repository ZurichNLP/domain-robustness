#! /usr/bin/python3

import sys
import json
import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--add", nargs='+', type=str, required=False,
                        help="List of strings to add to the vocab at the end.")

    args = parser.parse_args()

    return args


def main():
    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    vocab = {}

    for index, line in enumerate(sys.stdin):
        line = line.strip()
        parts = line.split("\t")

        item = parts[0]

        vocab[item] = index

    for item in args.add:
        index += 1
        vocab[item] = index

    json.dump(vocab, sys.stdout, ensure_ascii=False, indent=4)


if __name__ == '__main__':
    main()
