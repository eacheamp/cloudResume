# Api name
resource "aws_api_gateway_rest_api" "rest_api"{
    name        = var.rest_api_name
}
# Creating API resource
resource "aws_api_gateway_resource" "api_resource" {
    rest_api_id = aws_api_gateway_rest_api.rest_api.id
    parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
    path_part   = var.rest_api_resource_path_part
}
# Establishing API Method
resource "aws_api_gateway_method" "api_method" {
    rest_api_id   = aws_api_gateway_rest_api.rest_api.id
    resource_id   = aws_api_gateway_resource.api_resource.id
    http_method   = "GET" 
    authorization = "NONE" #Change
}

#CloudWatch
resource "aws_api_gateway_method_settings" "all" {
   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name     = aws_api_gateway_stage.rest_api_stage.stage_name
  method_path    = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_iam_role" "cloudwatchAPI_iam_role" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
  name = "PolicytoAllowCloudWatchLoggingonAPIGateway"
  role = "${aws_iam_role.cloudwatchAPI_iam_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

# lambda Integration
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}
# API Reponse
resource "aws_api_gateway_method_response" "rest_api__method_response_200"{
  rest_api_id       = aws_api_gateway_rest_api.rest_api.id
  resource_id       = aws_api_gateway_resource.api_resource.id
  http_method       = aws_api_gateway_method.api_method.http_method
  status_code       = "200"
}

#lambda resource based policy to allow the API gateway to invoke the lambda function
resource  "aws_lambda_permission" "api_gateway_lambda_policy"{
  statement_id    = "AllowlambdaExecutionFromAPIGateway"
  action          = "lambda:InvokeFunction"
  function_name   = var.lambda_function_name  
  principal       = "apigateway.amazonaws.com"
  source_arn      = "arn:aws:execute-api:${var.api_gateway_region}:${var.api_gateway_account_id}:${aws_api_gateway_rest_api.rest_api.id}/*/${aws_api_gateway_method.api_method.http_method}${aws_api_gateway_resource.api_resource.path}"  
}

# Deployments
resource "aws_api_gateway_deployment" "rest_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.api_method.id,
      aws_api_gateway_integration.api_integration.id
    ]))
  }
}

# Staging
resource "aws_api_gateway_stage" "rest_api_stage" {
  deployment_id = aws_api_gateway_deployment.rest_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.rest_api_stage_name
}