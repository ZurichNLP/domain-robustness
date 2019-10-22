#! /usr/bin/python3

import json
import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--nbest", type=str, help="File with nbest translations as JSON", required=True)
    parser.add_argument("--scores", type=str, nargs="+", help="File(s) with scores, one float per line in each file", required=True)
    parser.add_argument("--names", type=str, nargs="+", help="Names of scores, one per scores file", required=True)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)


    score_handles = []

    for scores_path in args.scores:
        score_handles.append(open(scores_path))

    with open(args.nbest) as nbest_handle:

        for line in nbest_handle:
            jobj = json.loads(line)

            translations = jobj["translations"]
            num_translations = len(translations)

            for name, score_handle in zip(args.names, score_handles):

                scores = []
                for _ in range(num_translations):
                    scores.append(next(score_handle))

                scores = [float(line.strip()) for line in scores]

                jobj[name] = scores

            print(json.dumps(jobj))


if __name__ == '__main__':
    main()
