# This module defines apigw api, lambda function and sns topic
# webhooks call the api, the lambda handles the request
# and publishes a message to the topic

variable "webhook_handler_version" {}
variable "globals" { type = "map" }

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
    s3_object_version = "${var.webhook_handler_version}"
    globals = "${var.globals}"
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
  function = "WebhookHandler"
  globals = "${var.globals}"
}

resource "aws_lambda_permission" "allow_invocation_from_apigw" {
    function_name = "${module.webhook_handler_lambda.function_arn}"
    statement_id = "allow_invocation_from_apigw"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.globals["region"]}:${var.globals["account"]}:*/*/*/*"
}

resource "aws_sns_topic" "repo_update" {
  name = "repo_update"
}

resource "aws_iam_role_policy" "allow_sns_publish" {
  name = "allow_sns_publish"
  role = "${module.webhook_handler_lambda.role_id}"
  policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "sns:Publish"
                ],
                "Effect": "Allow",
                "Resource": "${aws_sns_topic.repo_update.arn}"
            }
        ]
}
EOF
}

output "topic_arn" { value = "${aws_sns_topic.repo_update.arn}" }
