variable "aws_account" {}
variable "aws_region" {}
variable "aws_resource_prefix" {}
variable "s3_bucket" {}
variable "function_name" {}
variable "lambda_wheel_filename" {}
variable "lambda_wheel_s3_version" {}
variable "invocation_source_arn" {}

resource "aws_iam_role" "lambda" {
    name = "${var.aws_resource_prefix}_${var.function_name}"
    # this policy tells who can assume this role
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "lambda" {
    name = "allow_logs"
    role = "${aws_iam_role.lambda.id}"
    policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "logs:*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
}
EOF
}

resource "aws_lambda_function" "lambda" {
    function_name = "${var.aws_resource_prefix}_${var.function_name}"
    handler = "aws_lambda/${var.function_name}.handle_request"
    s3_bucket = "${var.s3_bucket}"
    s3_key = "${var.aws_resource_prefix}/${var.lambda_wheel_filename}"
    s3_object_version = "${var.lambda_wheel_s3_version}"
    role = "${aws_iam_role.lambda.arn}"
    runtime = "python2.7"
}

resource "aws_lambda_permission" "allow_api_gateway_to_invoke_handle_webhook_lambda" {
    function_name = "${aws_lambda_function.lambda.function_name}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "${var.invocation_source_arn }"
    #source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account}:*/*/*/*"
}

