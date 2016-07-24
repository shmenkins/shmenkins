#!/usr/bin/env bash

set -eo pipefail

# source bucket name from terraform variables file
source terraform.tfvars

# find the latest version of the lambda zip
S3_OBJECT_VERSION_ID=$(aws s3api list-object-versions \
    --bucket "$s3_bucket" \
    --prefix "lambda.zip" \
    --output text \
    --query "Versions[0].VersionId")

echo "S3 object version id: $S3_OBJECT_VERSION_ID"

terraform "$@" \
    -var="lambda_s3_object_version_id=$S3_OBJECT_VERSION_ID" \

