variable "s3_bucket" {}
variable "build_scheduled_topic_arn" {}

module "builder_lambda" {
  source = "../logging_lambda"
  name = "BuilderLambda"
  s3_bucket = "${var.s3_bucket}"
  env_vars = {
    BUCKET = "${var.s3_bucket}"
  }
}

# give the lambda function RO access to S3 bucket to get build tools
resource "aws_iam_role_policy" "allow_s3_getobject" {
  name = "allow_s3_getobject"
  role = "${module.builder_lambda.role_id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${var.s3_bucket}/*"
      }
    ]
}
EOF
}

module "bulid_on_build_scheduled_subscription" {
  source = "../sns_to_lambda_subscription"
  topic_arn = "${var.build_scheduled_topic_arn}"
  function_arn = "${module.builder_lambda.function_arn}"
}

