# output "rest_api_url" {
#   value = "${aws_api_gateway_deployment.rest_api_deployment.invoke_url}${aws_api_gateway_stage.rest_api_stage.stage_name}${aws_api_gateway_resource.api_resource.path}"
# }
output "http_api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}"
}
