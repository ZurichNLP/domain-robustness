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