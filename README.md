# domain-robustness

Scripts to reproduce our experiments on domain robustness

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

To preprocess training, development and test data, run

    ./scripts/preprocess_data.sh

Alternatively, to submit preprocessing as a SLURM job, run

    ./scripts/wrap-slurm-cpu-task.sh ./scripts/preprocess_data.sh

Most other CPU jobs can also be run by `wrap-slurm-cpu-task.sh`.

### Train baseline model

To train the baseline model, run

    ./scripts/training/train_multilingual.sh

Alternatively, to submit it as a SLURM job on S3IT:

    ./scripts/wrap-slurm-gpu-task.sh scripts/training/train_multilingual.sh

Check the status with

    squeue | grep [your username]

Cancel the job with

    scancel [job id]

### Train a multilingual baseline model

Submit as a job:

    ./scripts/wrap-slurm-gpu-task.sh scripts/training/train_multilingual.sh

### Train a reconstruction model

Submit as a job:

    ./scripts/wrap-slurm-gpu-task.sh scripts/training/train_reconstruction.sh

The reconstruction model is initialized with the multilingual baseline model, then fine-tuned.
This means that the multilingual baseline model must be trained before the reconstruction model.