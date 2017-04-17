variable "s3_bucket" {}

resource "aws_dynamodb_table" "sns_log" {
  name = "sns_log"
  read_capacity = 2
  write_capacity = 2
  hash_key = "interaction_id"
  attribute {
    name = "interaction_id"
    type = "S"
  }
  range_key = "timestamp"
  attribute {
    name = "timestamp"
    type = "S"
  }
}

module "sns_logger_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "sns_logger"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/sns_logger.zip"
  env_vars = {
    LOG_LEVEL = "DEBUG"
  }
}

resource "aws_lambda_permission" "allow_invocation_from_sns_build_scheduled" {
  function_name = "${module.sns_logger_lambda.function_arn}"
  statement_id = "allow_invocation_from_sns_build_scheduled"
  action = "lambda:InvokeFunction"
  principal = "sns.amazonaws.com"
  source_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_scheduled"
}

resource "aws_sns_topic_subscription" "invoke_lambda_on_build_scheduled" {
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_scheduled"
  protocol = "lambda"
  endpoint = "${module.sns_logger_lambda.function_arn}"
}

resource "aws_lambda_permission" "allow_invocation_from_sns_artifact_outdated" {
  function_name = "${module.sns_logger_lambda.function_arn}"
  statement_id = "allow_invocation_from_sns_artifact_outdated"
  action = "lambda:InvokeFunction"
  principal = "sns.amazonaws.com"
  source_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:artifact_outdated"
}

resource "aws_sns_topic_subscription" "invoke_lambda_on_artifact_outdated" {
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:artifact_outdated"
  protocol = "lambda"
  endpoint = "${module.sns_logger_lambda.function_arn}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
