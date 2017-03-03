variable "s3_bucket" {}
variable "maven_zip" { default = "apache-maven-3.3.9-bin.zip" }

resource "aws_s3_bucket_object" "apache_maven_3_3_9_bin_zip" {
  bucket = "${var.s3_bucket}"
  key = "${var.maven_zip}"
  source = "./modules/files/${var.maven_zip}"
  etag = "${md5(file("./modules/files/${var.maven_zip}"))}"
}
