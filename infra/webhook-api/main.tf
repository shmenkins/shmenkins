variable "s3_bucket" {}

# lambda
module "webhook_api_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "webhook_api"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/webhook-api.zip"
  env_vars = {
    TOPIC_ARN_BUILD_REQUEST = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_request"
    LOG_LEVEL = "DEBUG"
  }
}

module "allow_sns_publish" {
  source = "github.com/rzhilkibaev/allow_sns_publish.tf"
  role_id = "${module.webhook_api_lambda.role_id}"
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_request"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
