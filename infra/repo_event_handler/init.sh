#!/usr/bin/env bash

set -eo pipefail

rm -f terraform.tfvars
cfgen terraform.tfvars

source terraform.tfvars

rm -fr .terraform
terraform remote config \
    -backend=s3 \
    -backend-config="bucket=${s3_bucket}" \
    -backend-config="key=terraform.tfstate" \
    -backend-config="region=${aws_region}"

terraform get
