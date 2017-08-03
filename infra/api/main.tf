variable "s3_bucket" {}


data "aws_region" "current" {
  current = true
}

data "aws_caller_identity" "current" {}
