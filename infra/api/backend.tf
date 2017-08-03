terraform {
  backend "s3" {
    key = "api.tfstate"
    region = "us-west-2"
  }
}
