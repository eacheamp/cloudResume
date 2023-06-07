output "get_rest_api_url" {
  value = "${aws_api_gateway_deployment.get_rest_api_deployment.invoke_url}${aws_api_gateway_stage.get_rest_api_stage.stage_name}${aws_api_gateway_resource.get_api_resource.path}"
}
output "post_rest_api_url" {
  value = "${aws_api_gateway_deployment.post_rest_api_deployment.invoke_url}${aws_api_gateway_stage.post_rest_api_stage.stage_name}${aws_api_gateway_resource.put_api_resource.path}"
}