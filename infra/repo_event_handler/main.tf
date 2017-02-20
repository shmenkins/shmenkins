variable "webhook_handler_version" {}
variable "aws_profile" {}
variable "aws_account" {}
variable "aws_region" {}
variable "s3_bucket" {}

module "webhook_handler" {
  source = "./modules/webhook_handler"
  webhook_handler_version = "${var.webhook_handler_version}"
  globals = {
    profile = "${var.aws_profile}"
    account = "${var.aws_account}"
    region = "${var.aws_region}"
    s3_bucket = "${var.s3_bucket}"
  }
}

