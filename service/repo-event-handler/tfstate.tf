data "terraform_remote_state" "s3" {
  backend = "s3"
  config {
    bucket = "${var.tfstate_bucket}"
    key = "${var.tfstate_key}"
    region = "${var.aws_region}"
  }
}
