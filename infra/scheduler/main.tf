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

module "allow_sns_publish" {
  source = "github.com/rzhilkibaev/allow_sns_publish.tf"
  role_id = "${module.scheduler_lambda.role_id}"
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_scheduled"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
