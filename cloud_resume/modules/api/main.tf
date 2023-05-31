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
  rest_api_id          = aws_api_gateway_rest_api.rest_api.id
  resource_id          = aws_api_gateway_resource.api_resource.id
  http_method          = aws_api_gateway_method.api_methodGET.http_method
  type                 = "MOCK"
#   cache_key_parameters = ["method.request.path.param"]
#   cache_namespace      = "foobar"
#   timeout_milliseconds = 29000

#   request_parameters = {
#     "integration.request.header.X-Authorization" = "'static'"
#   }
request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

resource "aws_api_gateway_method_response" "rest_api_get_method_response_200"{
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_methodGET.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "rest_api_get_method_integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.api_methodGET.http_method
  status_code = aws_api_gateway_method_response.rest_api_get_method_response_200.status_code
    response_templates = {
        "application/json" = jsonencode({
        body = "Cloud Resume API!"
        })
    }
}
