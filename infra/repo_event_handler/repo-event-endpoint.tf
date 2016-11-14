resource "aws_api_gateway_rest_api" "api" {
  name = "${var.aws_resource_prefix}_repo_event_api"
  description = "Accepts repo events"
}

module "events_post" {
  source = "./api_method"
  aws_account = "${var.aws_account}"
  aws_region = "${var.aws_region}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  parent_id = "${aws_api_gateway_rest_api.api.root_resource_id}"
  path_part = "events"
  http_method = "POST"
  function = "repo_event_handler"
}
