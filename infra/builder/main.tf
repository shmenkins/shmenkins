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
}

module "lambda_event_source_sns" {
  source = "github.com/rzhilkibaev/lambda_event_source_sns.tf"
  topic_arn = "${aws_sns_topic.build_scheduled.arn}"
  function_arn = "${module.builder_lambda.function_arn}"
}
