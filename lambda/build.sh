#!/usr/bin/env bash

set -eo pipefail

./init.sh

source venv/bin/activate

nosetests
python setup.py bdist_wheel
