#! /usr/bin/python3

import json
import numpy
import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--nbest", type=str, help="File with nbest translations as JSON, containing all relevant scores.", required=True)
    parser.add_argument("--scores", type=str, nargs="+", help="Names of scores that should be considered", required=True)
    parser.add_argument("--weights", type=float, nargs="+", help="Weight for each score in --scores", required=True)

    args = parser.parse_args()

    return args


def argsort(seq):
    # http://stackoverflow.com/questions/3071415/efficient-method-to-calculate-the-rank-vector-of-a-list-in-python
    return sorted(range(len(seq)), key=seq.__getitem__, reverse=True)


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    assert numpy.sum(args.weights) == 1.0, "--weights must sum to 1.0"

    if any([weight < 0.0 or weight > 1.0 for weight in args.weights]):
        logging.error("weight in --weights must be between 0.0 and 1.0")

    with open(args.nbest) as nbest_handle:

        for line in nbest_handle:
            jobj = json.loads(line)

            # combine scores

            rerank_scores = []
            score_lists = [jobj[score_name] for score_name in args.scores]

            for score_tuple in zip(*score_lists):
                sum = 0.0
                for score, weight in zip(score_tuple, args.weights):
                    sum += (weight * score)
                rerank_scores.append(sum)

            jobj["rerank_scores"] = rerank_scores

            index = argsort(rerank_scores)

            # reorder translations with rerank scores

            translations = jobj["translations"]

            translations = [translations[i] for i in index]

            jobj["translations"] = translations

            print(json.dumps(jobj))


if __name__ == '__main__':
    main()
