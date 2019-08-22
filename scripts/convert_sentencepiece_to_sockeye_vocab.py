#! /usr/bin/python3

import sys
import json


def main():

    vocab = {}

    for index, line in enumerate(sys.stdin):
        line = line.strip()
        parts = line.split("\t")

        item = parts[0]

        vocab[item] = index

    json.dump(vocab, sys.stdout, ensure_ascii=False, indent=4)


if __name__ == '__main__':
    main()
