#!/usr/bin/env bash

set -eo pipefail

config_filename="lambda.cfg"

if [ ! -f "$config_filename" ]; then
    cfgen "$config_filename"
fi

source "$config_filename"

wheel_filename="lambda-0.0.1-py2-none-any.whl"

aws s3 cp dist/${wheel_filename} s3://${s3_bucket}/${aws_resource_prefix}/${wheel_filename}

