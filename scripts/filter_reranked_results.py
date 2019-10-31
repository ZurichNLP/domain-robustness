#! /usr/bin/python3

import sys

scores_all_systems = []

scores_per_system = []

for line in sys.stdin:
        if line.startswith("BLEU"):
                parts = line.split(" ")
                score = parts[2]
                scores_per_system.append(score)

                if len(scores_per_system) == 5:
                        scores_all_systems.append(scores_per_system)
                        scores_per_system = []

for scores in zip(*scores_all_systems):
        print("\t".join(scores))
