variable "s3_bucket" {}

# builder lambda
module "builder_lambda" {
  source    = "github.com/rzhilkibaev/logging_lambda.tf"
  name      = "builder"
  s3_bucket = "${var.s3_bucket}"
  s3_key    = "artifacts/builder.zip"

  env_vars = {
    LOG_LEVEL = "DEBUG"
  }
}

module "lambda_event_source_sns" {
  source       = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_name   = "build_scheduled"
  function_arn = "${module.builder_lambda.function_arn}"
}

module "allow_sns_publish" {
  source    = "github.com/rzhilkibaev/allow_sns_publish.tf"
  role_id   = "${module.builder_lambda.role_id}"
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_status_changed"
}

# A role that a build assumdss
resource "aws_iam_role" "cb_general" {
  name = "cb_general"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cb_general" {
  name        = "cb_general"
  role = "${aws_iam_role.cb_general.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::codepipeline-${data.aws_region.current.name}-*"
      ],
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
    }
  ]
}
EOF
}

data "aws_region" "current" {
  current = true
}

data "aws_caller_identity" "current" {}
