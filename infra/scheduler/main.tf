variable "s3_bucket" {}

# lambda
module "scheduler_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "scheduler"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/scheduler.zip"
}

module "lambda_event_source_sns" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:artifact_outdated"
  function_arn = "${module.scheduler_lambda.function_arn}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
