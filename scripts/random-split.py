#! /usr/bin/python3

import argparse
import logging
import random


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--input-src", type=str, help="Input file, source language", required=True)
    parser.add_argument("--input-trg", type=str, help="Input file, target language", required=True)
    parser.add_argument("--num-dev-lines", type=int, help="Number of lines in dev set", required=True)
    parser.add_argument("--output-train-src", type=str, help="Input file, target language", required=True)
    parser.add_argument("--output-train-trg", type=str, help="Input file, target language", required=True)
    parser.add_argument("--output-dev-src", type=str, help="Input file, target language", required=True)
    parser.add_argument("--output-dev-trg", type=str, help="Input file, target language", required=True)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    input_lines = []

    with open(args.input_src, "r") as input_handle_src, open(args.input_trg, "r") as input_handle_trg:

        for input_line_src, input_line_trg in zip(input_handle_src, input_handle_trg):

            input_lines.append((input_line_src, input_line_trg))

    random.shuffle(input_lines)

    dev_lines_left = args.num_dev_lines

    output_handle_train_src = open(args.output_train_src, "w")
    output_handle_train_trg = open(args.output_train_trg, "w")

    output_handle_dev_src = open(args.output_dev_src, "w")
    output_handle_dev_trg = open(args.output_dev_trg, "w")

    for line_tuple in input_lines:

        input_line_src, input_line_trg = line_tuple

        if dev_lines_left > 0:
            output_handle_dev_src.write(input_line_src)
            output_handle_dev_trg.write(input_line_trg)
        else:
            output_handle_train_src.write(input_line_src)
            output_handle_train_trg.write(input_line_trg)

        dev_lines_left -= 1


if __name__ == '__main__':
    main()
