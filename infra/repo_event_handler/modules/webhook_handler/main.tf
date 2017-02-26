# This module defines apigw api, lambda function and sns topic
# webhooks call the api, the lambda handles the request
# and publishes a message to the topic

variable "s3_bucket" {}

resource "aws_api_gateway_deployment" "webhook" {
  # change this to redeploy
  description = "1"
  # see https://github.com/hashicorp/terraform/issues/6613

  depends_on = ["module.events_post"]

  rest_api_id = "${aws_api_gateway_rest_api.webhook.id}"
  stage_name = "single"
}

module "webhook_handler_lambda" {
  source = "../logging_lambda"
  name = "WebhookLambda"
  s3_bucket = "${var.s3_bucket}"
  env_vars = {
    TOPIC_NAME = "${aws_sns_topic.repo_update.name}"
  }
}

resource "aws_api_gateway_rest_api" "webhook" {
  name = "webhook"
}

module "events_post" {
  source = "../api_method"
  rest_api_id = "${aws_api_gateway_rest_api.webhook.id}"
  parent_id = "${aws_api_gateway_rest_api.webhook.root_resource_id}"
  path_part = "events"
  http_method = "POST"
  function = "${module.webhook_handler_lambda.function_name}"
}

resource "aws_lambda_permission" "allow_invocation_from_apigw" {
  function_name = "${module.webhook_handler_lambda.function_name}"
  statement_id = "allow_invocation_from_apigw"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "${module.events_post.method_arn}"
}

resource "aws_sns_topic" "repo_update" {
  name = "repo_update"
}

module "allow_sns_publish" {
  source = "../allow_sns_publish_policy"
  role_id = "${module.webhook_handler_lambda.role_id}"
  topic_arn = "${aws_sns_topic.repo_update.arn}"
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" { }

output "repo_update_topic_arn" { value = "${aws_sns_topic.repo_update.arn}" }
