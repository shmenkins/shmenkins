variable "aws_account" {}
variable "aws_region" {}
variable "rest_api_id" {}
variable "parent_id" {}
variable "path_part" {}
variable "http_method" {}
variable "function" {}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = "${var.rest_api_id}"
  parent_id = "${var.parent_id}"
  path_part = "${var.path_part}"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${var.http_method}"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = "${var.rest_api_id}"
  resource_id = "${aws_api_gateway_resource.resource.id}"
  http_method = "${aws_api_gateway_method.method.http_method}"
  type = "AWS"
  integration_http_method = "POST"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/arn:aws:lambda:${var.aws_region}:${var.aws_account}:function:${var.function}/invocations"
}
