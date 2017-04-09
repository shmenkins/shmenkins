variable "s3_bucket" {}

# topic that the lambda listens to
resource "aws_sns_topic" "build_scheduled" {
  name = "build_scheduled"
}

# builder lambda
module "builder_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "builder"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/builder.zip"
  # arn:aws:sns:us-west-2:973368877303:build_status_change
  env_vars = {
    TOPIC_ARN_BUILD_STATUS_CHANGE = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_status_change"
  }
}

module "lambda_event_source_sns" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_arn = "${aws_sns_topic.build_scheduled.arn}"
  function_arn = "${module.builder_lambda.function_arn}"
}

module "allow_sns_publish" {
  source = "github.com/rzhilkibaev/allow_sns_publish.tf"
  role_id = "${module.builder_lambda.role_id}"
  topic_arn = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:build_status_change"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}
