#! /usr/bin/python3

import sys
import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--tag", type=str, help="Special tag to indicate language", required=True)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    num_bad = 0

    for line in sys.stdin:

        tokens = line.strip().split(" ")

        if tokens[0] == args.tag:
            tokens.pop(0)
        else:
            num_bad += 1

        line = " ".join(tokens)

        print(line)

    logging.debug("Wrong first token encountered: %d times" % num_bad)

if __name__ == '__main__':
    main()
