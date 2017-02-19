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
    name = "WebhookHandler"
    s3_object_version = "${var.webhook_handler_version}"
    globals = "${var.globals}"
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

