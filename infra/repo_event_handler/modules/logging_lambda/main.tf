# Lambda function that logs to CloudWatch

variable "name" {}
variable "globals" { type = "map" }

variable "memory_size" { default = 512 }
variable "timeout" { default = 5 }
variable "log_retention_in_days" { default = 30 }
variable "env_vars" { type = "map" }

data "aws_s3_bucket_object" "lambda_file" {
    bucket = "${var.globals["s3_bucket"]}"
    key = "artifacts/${var.name}.jar"
}

resource "aws_lambda_function" "lambda" {
    function_name = "${var.name}"
    handler = "com.shmenkins.infra.aws.lambda.${lower(var.name)}.${var.name}::handle"
    s3_bucket = "${data.aws_s3_bucket_object.lambda_file.bucket}"
    s3_key = "${data.aws_s3_bucket_object.lambda_file.key}"
    s3_object_version = "${data.aws_s3_bucket_object.lambda_file.version_id}"
    runtime = "java8"
    timeout = "${var.timeout}"
    memory_size = "${var.memory_size}"
    role = "${aws_iam_role.lambda.arn}"
    environment {
      variables = "${merge(map("AWS_ACCOUNT", "${data.aws_caller_identity.current.account_id}"), "${var.env_vars}")}"
    }
    # create lg first, then lambda
    # remove lambda first then lg
    depends_on = ["aws_cloudwatch_log_group.lambda"]
}

resource "aws_cloudwatch_log_group" "lambda" {
    name = "/aws/lambda/${var.name}"
    retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_iam_role" "lambda" {
    name = "${var.name}"
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
    name = "allow_logging"
    role = "${aws_iam_role.lambda.id}"
    policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": [
                  "logs:DescribeLogGroups"
                ],
                "Effect": "Allow",
                "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}"
            },
            {
                "Action": [
                  "logs:DescribeLogStreams",
                  "logs:CreateLogStream",
                  "logs:PutLogEvents"
                ],
                "Effect": "Allow",
                "Resource": "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.name}:log-stream:*"
            }
        ]
}
EOF
}

data "aws_region" "current" { current = true }

data "aws_caller_identity" "current" {}

output "function_arn" { value = "${aws_lambda_function.lambda.arn}" }
output "log_group_arn" { value = "${aws_cloudwatch_log_group.lambda.arn}" }
output "role_id" { value = "${aws_iam_role.lambda.id}" }
output "role_arn" { value = "${aws_iam_role.lambda.arn}" }
