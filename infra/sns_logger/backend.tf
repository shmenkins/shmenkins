terraform {
  backend "s3" {
    key = "sns-logger.tfstate"
    region = "us-west-2"
  }
}
