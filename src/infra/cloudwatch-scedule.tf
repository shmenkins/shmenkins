resource "aws_cloudwatch_event_rule" "every_minute" {
  name = "every_minute"
  description = "A scheduled event that fires every minute"
  schedule_expression = "rate(1 minute)"
  is_enabled = false
}

resource "aws_cloudwatch_event_target" "invoke_poll_source_code_repos" {
  rule = "${aws_cloudwatch_event_rule.every_minute.name}"
  arn = "${aws_lambda_function.poll_source_code_repos.arn}"
}

