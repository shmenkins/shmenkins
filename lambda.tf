variable "s3_bucket" {}
variable "lambda_zip_version" {}

resource "aws_iam_role" "shmenkins_lambda" {
    name = "shmenkins_lambda"
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

resource "aws_iam_role_policy" "shmenkins_lambda" {
    name = "shmenkins_lambda"
    role = "${aws_iam_role.shmenkins_lambda.id}"
    policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                    "logs:*",
                    "s3:*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
}
EOF
}

resource "aws_lambda_function" "handle_webhook" {
    s3_bucket = "${var.s3_bucket}"
    s3_key = "lambda.zip"
    s3_object_version = "${var.lambda_zip_version}"
    function_name = "handle_webhook"
    role = "${aws_iam_role.shmenkins_lambda.arn}"
    handler = "shmenkins/handle_webhook.handle"
    runtime = "python2.7"
}

resource "aws_lambda_permission" "allow_api_gateway_to_invoke_handle_webhook_lambda" {
    function_name = "${aws_lambda_function.handle_webhook.function_name}"
    statement_id = "AllowExecutionFromApiGateway"
    action = "lambda:InvokeFunction"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:${var.aws_region}:${var.aws_account_id}:*/*/*/*"
}
