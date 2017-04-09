variable "s3_bucket" {}

module "builder_lambda" {
  source = "github.com/rzhilkibaev/logging_lambda.tf"
  name = "builder"
  s3_bucket = "${var.s3_bucket}"
  s3_key = "artifacts/builder.zip"
}

