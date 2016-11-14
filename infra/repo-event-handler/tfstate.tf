data "terraform_remote_state" "s3" {
  backend = "s3"
  config {
    bucket = "${var.s3_bucket}"
    key = "${var.aws_resource_prefix}/repo_event_handler/terraform.tfstate"
    region = "${var.aws_region}"
  }
}
