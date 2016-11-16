#!/usr/bin/env bash

set -eo pipefail

./init.sh

source venv/bin/activate

./clean.sh

nosetests
python setup.py bdist_wheel
