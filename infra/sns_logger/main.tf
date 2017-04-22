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
  range_key = "message_timestamp"
  attribute {
    name = "message_timestamp"
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

module "lambda_event_source_sns_build_scheduled" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_name = "build_scheduled"
  function_arn = "${module.sns_logger_lambda.function_arn}"
}

module "lambda_event_source_sns_build_status_changed" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_name = "build_status_changed"
  function_arn = "${module.sns_logger_lambda.function_arn}"
}

module "lambda_event_source_sns_artifact_outdated" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_name = "artifact_outdated"
  function_arn = "${module.sns_logger_lambda.function_arn}"
}

resource "aws_iam_role_policy" "allow_dynamodb_put" {
  name = "allow_dynamodb_put"
  role = "${module.sns_logger_lambda.role_id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "dynamodb:PutItem"
        ],
        "Effect": "Allow",
        "Resource": "${aws_dynamodb_table.sns_log.arn}"
      }
    ]
}
EOF
}

#data "aws_region" "current" { current = true }

#data "aws_caller_identity" "current" {}
