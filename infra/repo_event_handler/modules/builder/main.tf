variable "s3_bucket" {}
variable "build_scheduled_topic_arn" {}

module "builder_lambda" {
  source = "../logging_lambda"
  name = "BuilderLambda"
  s3_bucket = "${var.s3_bucket}"
}

module "bulid_on_build_scheduled_subscription" {
  source = "../sns_to_lambda_subscription"
  topic_arn = "${var.build_scheduled_topic_arn}"
  function_arn = "${module.builder_lambda.function_arn}"
}

