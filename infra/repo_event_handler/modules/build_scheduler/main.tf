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

module "schedule_bulid_on_repo_change_subscription" {
  source = "../sns_to_lambda_subscription"
  topic_arn = "${var.repo_update_topic_arn}"
  function_arn = "${module.build_scheduler_lambda.function_arn}"
}

resource "aws_sns_topic" "build_scheduled" {
  name = "build_scheduled"
}

module "allow_sns_publish" {
  source = "../allow_sns_publish_policy"
  role_id = "${module.build_scheduler_lambda.role_id}"
  topic_arn = "${aws_sns_topic.build_scheduled.arn}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" { }

output "topic_arn" { value = "${aws_sns_topic.build_scheduled.arn}" }
