#!/usr/bin/env bash

set -eo pipefail

if [ ! -d 'venv' ]; then
    virtualenv venv
fi
