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

### Train baseline model

To train a baseline model on S3IT, activate the virtualenv if not done yet:

    source venvs/sockeye3/bin/activate
    
Then submit a job to SLURM:

    sbatch scripts/training/train_baseline.sh

Check the status with

    squeue

### Train a multilingual baseline model

Submit as a job:

    sbatch scripts/training/train_multilingual.sh

### Train a reconstruction model

Submit as a job:

    sbatch scripts/training/train_reconstruction.sh

The reconstruction model is initialized with the multilingual baseline model.
This means that the multilingual baseline model must be trained before the reconstruction model.