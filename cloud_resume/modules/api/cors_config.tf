resource "aws_api_gateway_resource" "cors_resourceGET" {
  rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
  parent_id   = aws_api_gateway_rest_api.get_rest_api.root_resource_id
  path_part   = "{cors+}"
}
resource "aws_api_gateway_resource" "cors_resourcePOST" {
  rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
  parent_id   = aws_api_gateway_rest_api.put_rest_api.root_resource_id
  path_part   = "{cors+}"
}
resource "aws_api_gateway_method" "cors_methodGET" {
  rest_api_id   = aws_api_gateway_rest_api.get_rest_api.id
  resource_id   = aws_api_gateway_resource.cors_resourceGET.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_method" "cors_methodPOST" {
  rest_api_id   = aws_api_gateway_rest_api.put_rest_api.id
  resource_id   = aws_api_gateway_resource.cors_resourcePOST.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "cors_integrationGET" {
  rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourceGET.id
  http_method = aws_api_gateway_method.cors_methodGET.http_method
  type = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode=200
    })
  }
}
resource "aws_api_gateway_integration" "cors_integrationPOST" {
  rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourcePOST.id
  http_method = aws_api_gateway_method.cors_methodPOST.http_method
  type = "MOCK"
  request_templates = {
    "application/json" = jsonencode({
      statusCode=200
    })
  }
}
resource "aws_api_gateway_method_response" "cors_responseGET" {
  depends_on = [aws_api_gateway_method.cors_methodGET]
  rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourceGET.id
  http_method = aws_api_gateway_method.cors_methodGET.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_method_response" "cors_responsePOST" {
  depends_on = [aws_api_gateway_method.cors_methodPOST]
  rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourcePOST.id
  http_method = aws_api_gateway_method.cors_methodPOST.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
  response_models = {
    "application/json" = "Empty"
  }
}
resource "aws_api_gateway_integration_response" "cors_integration_responseGET" {
  depends_on = [aws_api_gateway_integration.cors_integrationGET, aws_api_gateway_method_response.cors_responseGET]
  rest_api_id = aws_api_gateway_rest_api.get_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourceGET.id
  http_method = aws_api_gateway_method.cors_methodGET.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", 
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS'" 
  }
}
resource "aws_api_gateway_integration_response" "cors_integration_responsePOST" {
  depends_on = [aws_api_gateway_integration.cors_integrationPOST, aws_api_gateway_method_response.cors_responsePOST]
  rest_api_id = aws_api_gateway_rest_api.put_rest_api.id
  resource_id = aws_api_gateway_resource.cors_resourcePOST.id
  http_method = aws_api_gateway_method.cors_methodPOST.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'", 
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET, OPTIONS,POST'" 
  }
}