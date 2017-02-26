variable "aws_profile" {}
variable "aws_account" {}
variable "aws_region" {}
variable "s3_bucket" {}

module "webhook_handler" {
  source = "./modules/webhook_handler"
  s3_bucket = "${var.s3_bucket}"
}

module "build_scheduler" {
  source = "./modules/build_scheduler"
  s3_bucket = "${var.s3_bucket}"
  repo_update_topic_arn = "${module.webhook_handler.repo_update_topic_arn}"
}

