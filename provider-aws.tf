variable "aws_credentials" {}
variable "aws_account_id" {}
variable "aws_region" {}

provider "aws" {
    shared_credentials_file  = "${var.aws_credentials}"
    region = "${var.aws_region}"
}
