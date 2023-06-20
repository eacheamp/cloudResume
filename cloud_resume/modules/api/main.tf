resource "aws_apigatewayv2_api" "http_api"{
    name          = var.api_name
    protocol_type = "HTTP"

    cors_configuration {
      allow_origins     = ["https://eacheampong.work"]
      allow_credentials = "true" 
      allow_headers     = ["*"]
      allow_methods     = ["*"]
      max_age           = 300
  }
}

resource "aws_apigatewayv2_stage" "api_stagev2" {
  api_id              = aws_apigatewayv2_api.http_api.id
  name                = var.http_api_stage_name
  auto_deploy         = true 
  # deployment_id       = aws_apigatewayv2_deployment.api_deploymentv2.id
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id              = aws_apigatewayv2_api.http_api.id
  integration_type    = "AWS_PROXY"
  
  integration_uri     = var.lambda_function_arn
  integration_method  = "POST"
}

resource "aws_apigatewayv2_route" "api_post_route" {
  api_id              = aws_apigatewayv2_api.http_api.id

  route_key            = "POST /getcount"
  target               = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# resource "aws_apigatewayv2_deployment" "api_deploymentv2" {
#   api_id      = aws_apigatewayv2_api.http_api.id
#   description = "API deployment"

#   triggers = {
#     redeployment = sha1(join(",", tolist([
#       jsonencode(aws_apigatewayv2_api.http_api),
#       jsonencode(aws_apigatewayv2_route.api_route),
#     ])))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }