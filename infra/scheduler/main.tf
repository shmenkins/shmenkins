variable "s3_bucket" {}

# topic that the lambda listens to
resource "aws_sns_topic" "artifact_out_of_date" {
  name = "artifact_out_of_date"
}

# lambda
module "scheduler_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "scheduler"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/scheduler.zip"
}

module "lambda_event_source_sns" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_arn = "${aws_sns_topic.artifact_out_of_date.arn}"
  function_arn = "${module.scheduler_lambda.function_arn}"
}
