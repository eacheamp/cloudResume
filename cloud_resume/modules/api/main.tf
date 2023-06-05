resource "aws_api_gateway_rest_api" "rest_api"{
    name        = var.rest_api_name
}
resource "aws_api_gateway_resource" "api_resource" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
    path_part   = var.rest_api_resource_path_part
}
resource "aws_api_gateway_method" "api_methodGET" {
    rest_api_id   = aws_api_gateway_rest_api.rest_api.id
    resource_id   = aws_api_gateway_resource.api_resource.id
    http_method   = "GET"
    authorization = "NONE" #Change
}
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_methodGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}
resource "aws_api_gateway_method_response" "rest_api_get_method_response_200"{
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_methodGET.http_method
  status_code = "200"
}
#lambda resource based policy to allow the API gateway to invoke the lambda function
resource  "aws_lambda_permission" "api_gateway_lambda_policy"{
  statement_id    = "AllowlambdaExecutionFromAPIGateway"
  action          = "lambda:InvokeFunction"
  function_name   = var.lambda_function_name  
  principal       = "apigateway.amazonaws.com"
  source_arn      = "arn:aws:execute-api:${var.api_gateway_region}:${var.api_gateway_account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.api_methodGET.http_method}${aws_api_gateway_resource.api_resource.path}"  
}
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.api_methodGET.id,
      aws_api_gateway_integration.api_integration.id
    ]))
  }
}
resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.rest_api_stage_name
}