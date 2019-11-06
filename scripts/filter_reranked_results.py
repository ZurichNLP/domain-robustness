#! /usr/bin/python3

from pathlib import Path
import os
import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--bleu-reranked-model-folder", type=str, help="Folder in bleu_reranked with weight combinations as subfolders.", required=True)
    parser.add_argument("--formatted", action="store_true", help="Print string to copy to results sheet.", required=False, default=False)

    args = parser.parse_args()

    return args


def extract_score_from_file(filepath: str) -> float:
    """

    :param filepath:
    :return:
    """
    with open(filepath) as handle:
        line = handle.readline()
        if line.strip() == "":
            logging.warning("File seems to be empty: %s" % filepath)
            return 0.0
        parts = line.split(" ")

        return float(parts[2])

def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    collected_pairs = []

    for root, _, files in os.walk(args.bleu_reranked_model_folder):
        for file in files:
            file_path = os.path.join(root, file)
            logging.debug("Found file: %s" % file_path)
            pl_path = Path(file_path)
            score = extract_score_from_file(file_path)
            collected_pairs.append((score, pl_path.parent))

    if args.formatted:
        scores = [str(score) for score, name in sorted(collected_pairs, key = lambda x: x[1])]
        names = [str(name) for score, name in sorted(collected_pairs, key=lambda x: x[1])]

        print("\t".join(names))
        print("\t".join(scores))
    else:
        for score, name in sorted(collected_pairs, reverse=True):
            print("%f\t%s" % (score, name))


if __name__ == '__main__':
    main()
