terraform {
  backend "s3" {
    key = "builder.tfstate"
    region = "us-west-2"
  }
}
