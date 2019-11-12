# domain-robustness

Scripts to reproduce our experiments on domain robustness.

## Basic Setup

### Install required software

Create a new virtualenv that uses Python 3. Please make sure to run this command outside of
any virtual Python environment:

    ./scripts/make_virtualenv.sh

**Important**: Then activate the env by executing the `source` command that is output by the shell
script above.

Download and install required software:

    ./scripts/download_install_packages.sh

### Download and unzip data

To download data that is already prepared, run

    ./scripts/download_data.sh

### Preprocess data

To preprocess all data sets, run

    ./scripts/preprocess_all.sh

To process only one specific language pair, run one of the specific scripts in `scripts/preprocessing`.

## Running on clusters with SLURM

All training, preprocessing, translation and scoring scripts can be submitted as batch jobs to a SLURM batch system. If you are on a SLURM cluster, call scripts as follows:

    [wrapper-script] [actual script to run]
    
Examples:

    ./scripts/wrap-slurm-gpu-training-task.sh scripts/training/train_transformer_multilingual_de_en.sh
    ./scripts/wrap-slurm-gpu-translation-task.sh scripts/translation/translate_baseline.sh

Adapt the wrapper scripts to your needs first.

## Training

### Train an individual model

To train an individual model, select a script from `scripts/training`, then run

    ./scripts/training/train_transformer_multilingual_de_en.sh

### Train all models

Instead of executing individual scripts, consider running:

    ./scripts/training/train_all.sh

This will submit individual model trainings as SLURM jobs. Edit the script to change which models are trained.

Please note: Not all models can be trained at the same time. Examples:
- the distillation model depends on translations from the Transformer baseline
- the reconstruction model is initialized with a multilingual model

## Translation

Translate the test set and dev set with a trained model as follows:

    ./scripts/wrap-slurm-gpu-translation-task.sh scripts/translation/translate_baseline.sh

This will translate the dev and test data with an beam size and nbest size of 50 by default,
but also produce 1-best translations of the test set with a beam size of 10.

## Evaluation

To evaluate with sacrebleu, run

    ./scripts/evaluation/evaluate_all.sh

The evaluation script must be run inside the `sockeye3` virtualenv.

## Language Model Training

All scripts concerning the language model are in `scripts/lm`. fairseq needs a different virtualenv:

    # run *outside* of any virtualenv
    ./scripts/lm/make_virtualenv.sh
    # run after activating the virtualenv
    ./scripts/lm/install_packages.sh


Then execute the following commands (taking the DE-EN language model trained on subwords as an example):

    ./scripts/lm/preprocessing/preprocess_data_de_en.sh
    ./scripts/lm/training/train_lm_de_en.sh

Again, both commands can be submitted as batch jobs.

## Scoring

If you have 1) trained NMT models, 2) produced nbest translations and 3) trained suitable language models, you can use those models to score nbest translations.

### Scoring with an individual model

Run, for example,

    ./scripts/scoring/score_reconstruction_de_en.sh

### Scoring all models

Run

    ./scripts/scoring/score_all.sh

## Reranking

After scoring nbest lists for development data, you can search for the ideal weight combination as follows:

    ./scripts/reranking/rerank_grid_search_transformer_reconstruction_de_en.sh

This will give you a list of weight combinations sorted by dev BLEU.

After editing the file to add the best weight combination, run

    ./scripts/reranking/rerank_best_weight_transformer_reconstruction_de_en.sh
    
Which will rerank the nbest lists with the weighted scores and evaluate BLEU on the test set.

## Citation

If you use this code, please cite

Müller, Mathias; Rios, Annette; Sennrich, Rico (2019): Domain Robustness in Neural Machine Translation. ArXiv Preprint: https://arxiv.org/abs/1911.03109.

```
# ArXiv BibTeX
```
