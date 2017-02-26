variable "topic_arn" {}
variable "function_arn" {}

resource "aws_lambda_permission" "allow_invocation_from_sns" {
  function_name = "${var.function_arn}"
  statement_id = "allow_invocation_from_sns"
  action = "lambda:InvokeFunction"
  principal = "sns.amazonaws.com"
  source_arn = "${var.topic_arn}"
}

resource "aws_sns_topic_subscription" "invoke_lambda_on_topic_event" {
    topic_arn = "${var.topic_arn}"
    protocol = "lambda"
    endpoint = "${var.function_arn}"
}

