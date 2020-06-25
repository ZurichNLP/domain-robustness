#! /usr/bin/python3

import os

import argparse
import logging

from operator import attrgetter
from collections import namedtuple
from typing import Tuple


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--folder", type=str, help="Folder to search for BLEU results", required=True)
    parser.add_argument("--num-tabs", type=int, help="Number of tabs between values",
                        required=False, default=1)
    parser.add_argument("--sort", type=str, help="sort results by forward, backward or lm",
                        required=False, default=None, choices=["forward", "backward", "lm", "bleu"])
    args = parser.parse_args()

    return args


Result = namedtuple('Result', ["lm", "forward", "backward", "bleu", "corpus", "domain"])


def tab(r: Result) -> str:
    """

    :param r:
    :return:
    """
    parts = [r.lm, r.forward, r.backward, r.bleu, r.corpus, r.domain]
    return "\t".join(parts)


def extract_bleu_from_file(path: str) -> str:
    """

    :param path:
    :return:
    """
    with open(path, "r") as handle:
        line = handle.readline()
        parts = line.split(" ")
        bleu = parts[2]

        return bleu

def parse_dirname(dirname: str) -> Tuple[str, str, str]:
    """

    :param dirname:
    :return:
    """
    parts = dirname.split("/")
    weights = parts[-1]

    return weights[:4], weights[4:8], weights[8:]


def extract_domain_from_filename(filename: str) -> str:
    """

    :param filename:
    :return:
    """
    parts = filename.split(".")

    return parts[-2]

def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    results = []

    for root, dirs, files in os.walk(args.folder):

        for file in files:
            if file.endswith(".bleu"):

                file_path = os.path.join(root, file)
                dir_name = os.path.dirname(file_path)

                forward, backward, lm = parse_dirname(dir_name)
                bleu = extract_bleu_from_file(file_path)

                if "dev" in file:
                    corpus = "dev"
                else:
                    corpus = "test"

                domain = extract_domain_from_filename(file)

                r = Result(lm, forward, backward, bleu, corpus, domain)
                results.append(r)

    if args.sort is not None:
        results.sort(key=attrgetter("corpus", "domain", args.sort))

    joiner = "\t" * args.num_tabs
    print(joiner.join(["LM", "FWD", "BWD", "BLEU", "CORPUS", "DOMAIN"]))

    for r in results:
        print(tab(r))


if __name__ == '__main__':
    main()
