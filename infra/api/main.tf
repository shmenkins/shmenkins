variable "s3_bucket" {}

resource "aws_api_gateway_rest_api" "shmenkins" {
  name = "shmenkins"
}

resource "null_resource" "swagger" {
  triggers {
    swagger_file_hash = "${sha1(file("api.yaml"))}"
  }

  provisioner "local-exec" {
    command = <<EOF
      aws apigateway put-rest-api \
        --profile=shmenkins \
        --region=${data.aws_region.current.name} \
        --mode=overwrite \
        --rest-api-id=${aws_api_gateway_rest_api.shmenkins.id} \
        --body='file://api.yaml'
EOF
  }

  depends_on = ["aws_api_gateway_rest_api.shmenkins"]
}

data "aws_region" "current" {
  current = true
}

data "aws_caller_identity" "current" {}
