#! /usr/bin/python3

import argparse
import logging

import torch
from fairseq.models.transformer_lm import TransformerLanguageModel


LOG_INTERVAL = 10000

SCORE_TYPE_PPL="perplexity"
SCORE_TYPE_LOGPROB="logprob"
SCORE_TYPE_NEGLOGPROB="neglogprob"


SCORE_TYPES=[SCORE_TYPE_PPL,
             SCORE_TYPE_LOGPROB,
             SCORE_TYPE_NEGLOGPROB]


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model", type=str, help="Path where model file is stored.", required=True)
    parser.add_argument("--input", type=str, help="File to score, line by line.", required=True)
    parser.add_argument("--output", type=str, help="File to save scores to.", required=True)

    parser.add_argument("--score-type", type=str, choices=SCORE_TYPES, help="Type of LM score.", required=False,
                        default=SCORE_TYPE_LOGPROB)
    parser.add_argument("--cuda", action="store_true", help="Move LM to GPU before scoring.",
                        required=False, default=False)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    lm = TransformerLanguageModel.from_pretrained(args.model, 'checkpoint_best.pt')

    # disable dropout

    lm.eval()

    if args.cuda:
        lm.cuda()

    with open(args.input, "r") as infile:
        num_lines = sum(1 for line in infile)
        logging.debug("Number of lines in input file: %d" % num_lines)

    seen = 0

    with open(args.input, "r") as infile, open(args.output, "w") as outfile:
        for line in infile:
            line = line.strip()

            score = lm.score(line)['positional_scores'].mean()

            if args.score_type in [SCORE_TYPE_PPL, SCORE_TYPE_NEGLOGPROB]:
                score = score.neg()

            if args.score_type == SCORE_TYPE_PPL:
                score = score.exp()

            outfile.write("%f\n" % score)

            seen += 1

            if seen % LOG_INTERVAL == 0:
                logging.debug("Processed lines: %d / %d" % (seen, num_lines))


if __name__ == '__main__':
    main()