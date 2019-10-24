#! /usr/bin/python3

import argparse
import logging
import torch
import copy

from fairseq import hub_utils
from fairseq.models.fairseq_model import FairseqLanguageModel


class GeneratorHubInterfaceWithScoring(hub_utils.GeneratorHubInterface):

    def score(self,
              sentence: str,
              verbose: bool = False,
              **kwargs) -> float:

        tokens = sentence.split(" ")
        num_tokens = len(tokens)

        encoded_sentence = self.binarize(sentence)
        sample = self._build_sample(encoded_sentence)

        # build generator using current args as well as any kwargs
        gen_args = copy.copy(self.args)
        gen_args.beam = 1
        gen_args.max_len_b = num_tokens
        for k, v in kwargs.items():
            setattr(gen_args, k, v)
        generator = self.task.build_generator(gen_args)

        translations = self.task.inference_step(generator, self.models, sample)

        hypo = translations[0][0]
        score = hypo['score']

        scored_tokens = hypo['tokens']
        scored_sentence = self.string(scored_tokens)

        assert sentence == scored_sentence, "Input tokens and the ones that are actually scored do not seem identical:\n%s\n%s" % (sentence, scored_sentence)

        if verbose:
            print("TOKENS:\t%s" % scored_tokens)

        return score


class FairseqLanguageModelWithScoring(FairseqLanguageModel):

    @classmethod
    def from_pretrained(cls, model_name_or_path, checkpoint_file='model.pt', data_name_or_path='.', **kwargs):

        x = hub_utils.from_pretrained(
            model_name_or_path,
            checkpoint_file,
            data_name_or_path,
            archive_map=cls.hub_models(),
            **kwargs,
        )
        print(x['args'])
        return GeneratorHubInterfaceWithScoring(x['args'], x['task'], x['models'])


def parse_args():
    parser = argparse.ArgumentParser()

    parser.add_argument("--model-dir", type=str, help="Path where model file is stored.", required=True)
    parser.add_argument("--input", type=str, help="File to score, line by line.", required=True)
    parser.add_argument("--output", type=str, help="File to save scores to.", required=True)

    args = parser.parse_args()

    return args


def main():

    args = parse_args()

    logging.basicConfig(level=logging.DEBUG)
    logging.debug(args)

    custom_lm = FairseqLanguageModelWithScoring.from_pretrained(args.model_dir, 'checkpoint_best.pt')

    with open(args.input, "r") as infile, open(args.output, "w") as outfile:
        for line in infile:
            line = line.strip()
            outfile.write("%f\n" % custom_lm.score(line))


if __name__ == '__main__':
    main()