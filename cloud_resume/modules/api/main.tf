# Api name
resource "aws_api_gateway_rest_api" "get_rest_api"{
    name        = var.fetch_rest_api_name
}
resource "aws_api_gateway_rest_api" "put_rest_api"{
    name        = var.update_rest_api_name
}
# Creating API resource
resource "aws_api_gateway_resource" "get_api_resource" {
    rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
    parent_id   = aws_api_gateway_rest_api.get_rest_api.root_resource_id
    path_part   = var.fetch_rest_api_resource_path_part
}
resource "aws_api_gateway_resource" "put_api_resource" {
    rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
    parent_id   = aws_api_gateway_rest_api.put_rest_api.root_resource_id
    path_part   = var.update_rest_api_resource_path_part
}
# Establishing API Method
resource "aws_api_gateway_method" "api_methodGET" {
    rest_api_id   = aws_api_gateway_rest_api.get_rest_api.id
    resource_id   = aws_api_gateway_resource.get_api_resource.id
    http_method   = "GET"
    authorization = "NONE" #Change
}
resource "aws_api_gateway_method" "api_methodPOST" {
    rest_api_id   = aws_api_gateway_rest_api.put_rest_api.id
    resource_id   = aws_api_gateway_resource.put_api_resource.id
    http_method   = "POST"
    authorization = "NONE" #Change
}
# lambda Integration
resource "aws_api_gateway_integration" "api_integrationGET" {
  rest_api_id             = aws_api_gateway_rest_api.get_rest_api.id
  resource_id             = aws_api_gateway_resource.get_api_resource.id
  http_method             = aws_api_gateway_method.api_methodGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.getlambda_function_arn
}
resource "aws_api_gateway_integration" "api_integrationPOST" {
  rest_api_id             = aws_api_gateway_rest_api.put_rest_api.id
  resource_id             = aws_api_gateway_resource.put_api_resource.id
  http_method             = aws_api_gateway_method.api_methodPOST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.putlambda_function_arn

}
# API Reponse
resource "aws_api_gateway_method_response" "rest_api_get_method_response_200"{
  rest_api_id       = aws_api_gateway_rest_api.get_rest_api.id
  resource_id       = aws_api_gateway_resource.get_api_resource.id
  http_method       = aws_api_gateway_method.api_methodGET.http_method
  status_code       = "200"
}
resource "aws_api_gateway_method_response" "rest_api_put_method_response_200"{
  rest_api_id       = aws_api_gateway_rest_api.put_rest_api.id
  resource_id       = aws_api_gateway_resource.put_api_resource.id
  http_method       = aws_api_gateway_method.api_methodPOST.http_method
  status_code       = "200"
}
#lambda resource based policy to allow the API gateway to invoke the lambda function
resource  "aws_lambda_permission" "api_gateway_lambda_policyGET"{
  statement_id    = "AllowlambdaExecutionFromAPIGatewayGET"
  action          = "lambda:InvokeFunction"
  function_name   = var.getlambda_function_name  
  principal       = "apigateway.amazonaws.com"
  source_arn      = "arn:aws:execute-api:${var.api_gateway_region}:${var.api_gateway_account_id}:${aws_api_gateway_rest_api.get_rest_api.id}/*/${aws_api_gateway_method.api_methodGET.http_method}${aws_api_gateway_resource.get_api_resource.path}"  
}
resource  "aws_lambda_permission" "api_gateway_lambda_policyPUT"{
  statement_id    = "AllowlambdaExecutionFromAPIGatewayPUT"
  action          = "lambda:InvokeFunction"
  function_name   = var.putlambda_function_name
  principal       = "apigateway.amazonaws.com"
  source_arn      = "arn:aws:execute-api:${var.api_gateway_region}:${var.api_gateway_account_id}:${aws_api_gateway_rest_api.put_rest_api.id}/*/${aws_api_gateway_method.api_methodPOST.http_method}${aws_api_gateway_resource.put_api_resource.path}"  
}
# Deployments
resource "aws_api_gateway_deployment" "get_rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.get_api_resource.id,
      aws_api_gateway_method.api_methodGET.id,
      aws_api_gateway_integration.api_integrationGET.id
    ]))
  }
}
resource "aws_api_gateway_deployment" "post_rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.put_api_resource.id,
      aws_api_gateway_method.api_methodPOST.id,
      aws_api_gateway_integration.api_integrationPOST.id
    ]))
  }
}
# Staging
resource "aws_api_gateway_stage" "get_rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.get_rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.get_rest_api.id
  stage_name    = var.rest_api_stage_name
}
resource "aws_api_gateway_stage" "post_rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.post_rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.put_rest_api.id
  stage_name    = var.rest_api_stage_name
}