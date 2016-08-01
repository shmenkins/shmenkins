variable "s3_bucket" {}
variable "s3_object_version_id_poll_source_code_repos_py_zip" {}

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
                    "logs:*"
                ],
                "Effect": "Allow",
                "Resource": "*"
            }
        ]
}
EOF
}

resource "aws_lambda_permission" "rule_every_minute_triggers_poll_source_code_repos" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.poll_source_code_repos.arn}"
    principal = "events.amazonaws.com"
}

resource "aws_lambda_function" "poll_source_code_repos" {
    s3_bucket = "${var.s3_bucket}"
    s3_key = "lambda.zip"
    s3_object_version = "${var.s3_object_version_id_poll_source_code_repos_py_zip}"
    function_name = "poll_source_code_repos"
    role = "${aws_iam_role.shmenkins_lambda.arn}"
    handler = "lambda/poll_source_code_repos.lambda_handler"
    runtime = "python2.7"
}
