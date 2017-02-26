variable "s3_bucket" {}
variable "repo_update_topic_arn" {}

module "build_scheduler_lambda" {
  source = "../logging_lambda"
  name = "BuildSchedulerLambda"
  s3_bucket = "${var.s3_bucket}"
  env_vars = {
    TOPIC_NAME = "${aws_sns_topic.build_scheduled.name}"
  }
}

resource "aws_lambda_permission" "allow_invocation_from_sns" {
  function_name = "${module.build_scheduler_lambda.function_name}"
  statement_id = "allow_invocation_from_sns"
  action = "lambda:InvokeFunction"
  principal = "sns.amazonaws.com"
  source_arn = "${var.repo_update_topic_arn}"
}

resource "aws_sns_topic" "build_scheduled" {
  name = "build_scheduled"
}

resource "aws_sns_topic_subscription" "schedule_bulid_on_repo_change" {
    topic_arn = "${var.repo_update_topic_arn}"
    protocol = "lambda"
    endpoint = "${module.build_scheduler_lambda.function_arn}"
}

module "allow_sns_publish" {
  source = "../allow_sns_publish_policy"
  role_id = "${module.build_scheduler_lambda.role_id}"
  topic_arn = "${aws_sns_topic.build_scheduled.arn}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" { }

output "topic_arn" { value = "${aws_sns_topic.build_scheduled.arn}" }
