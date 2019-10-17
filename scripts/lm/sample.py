#! /usr/bin/python3

import argparse
import logging

from fairseq.models.transformer_lm import TransformerLanguageModel


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model-dir", type=str, help="Path where model file is stored.", required=True)
    parser.add_argument("--prefix", type=str, help="Prefix as context for sampling.", required=True)
    parser.add_argument("--verbose", action="store_true", type=bool, help="Verbose output of scores.", default=False, required=False)

    parser.add_argument("--sample-length", type=int, help="Length of sample to be generated (total length will be length of prefix + sample_length).",
                        default=200, required=False)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    tokens = args.prefix.split(" ")
    num_tokens = len(tokens)

    assert args.sample_length >= num_tokens, "--sample-length (%d) must be equal to or higher than length of --prefix (%d)" % (args.sample_length, num_tokens)

    actual_length = args.sample_length - num_tokens

    custom_lm = TransformerLanguageModel.from_pretrained(args.model_dir, 'checkpoint_best.pt', verbose=args.verbose, max_len_b=actual_length)
    print(custom_lm.sample(args.prefix, beam=5))


if __name__ == '__main__':
    main()
