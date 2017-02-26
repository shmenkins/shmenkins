variable "role_id" {}
variable "topic_arn" {}

resource "aws_iam_role_policy" "allow_sns_publish" {
  name = "allow_sns_publish"
  role = "${var.role_id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "sns:Publish"
        ],
        "Effect": "Allow",
        "Resource": "${var.topic_arn}"
      }
    ]
}
EOF
}
