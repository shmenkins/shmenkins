variable "aws_profile" {}
variable "aws_account" {}
variable "aws_region" {}
variable "aws_resource_prefix" {}
variable "s3_bucket" {}
variable "lambda_wheel_filename" {}
variable "lambda_wheel_s3_version" {}

resource "aws_api_gateway_rest_api" "api" {
  name = "${var.aws_resource_prefix}_repo_event_api"
  description = "Accepts repo events"
}

module "events_post" {
  source = "./modules/api_method"
  aws_account = "${var.aws_account}"
  aws_region = "${var.aws_region}"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part = "events"
  http_method = "POST"
  function = "repo_event_handler"
}

module "repo_event_handler_lambda" {
  source = "./modules/repo_event_handler_lambda"
  function_name = "repo_event_handler"
  aws_account = "${var.aws_account}"
  aws_region = "${var.aws_region}"
  aws_resource_prefix = "${var.aws_resource_prefix}"
  s3_bucket = "${var.s3_bucket}"
  lambda_wheel_filename = "${var.lambda_wheel_filename}"
  lambda_wheel_s3_version = "${var.lambda_wheel_s3_version}"
  invocation_source_arn = "${module.events_post.method_arn}"
}
