#! /usr/bin/python3

import argparse
import logging


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model-dir", type=str, help="Path where model file is stored.", required=True)
    parser.add_argument("--prefix", type=str, help="Prefix as context for sampling.", default=64)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    from fairseq.models.transformer_lm import TransformerLanguageModel

    custom_lm = TransformerLanguageModel.from_pretrained(args.model_dir, 'checkpoint_best.pt', tokenizer='moses',
                                                         bpe='fastbpe')
    print(custom_lm.sample(args.prefix, beam=5))


if __name__ == '__main__':
    main()
