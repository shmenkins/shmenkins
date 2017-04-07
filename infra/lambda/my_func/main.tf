terraform {
  backend "s3" {
    bucket = "shmenkins-us-west-2"
    key = "my_func"
    region = "us-west-2"
  }
}

provider "aws" {
  profile = "default"
  region = "us-west-2"
}

module "lambda" {
  source = "github.com/rzhilkibaev/lambda.tf?ref=v1.0"
  function_name = "my_func"
}

output "function_arn" { value = "${module.lambda.function_arn}" }
output "function_qualified_arn" { value = "${module.lambda.function_qualified_arn}" }
output "function_version" { value = "${module.lambda.function_version}" }
output "role_arn" { value = "${module.lambda.role_arn}" }
