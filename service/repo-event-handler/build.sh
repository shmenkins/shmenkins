#!/usr/bin/env bash

set -eo pipefail

rm -f terraform.tfvars
cfgen terraform.tfvars
terraform get
terraform apply
