terraform {
  backend "s3" {
    key = "foundation.tfstate"
    region = "us-west-2"
  }
}
