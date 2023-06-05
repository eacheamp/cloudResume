variable "rest_api_name" {
    type        = string
    description = "Name of api gateway rest_api created"
    default     = "cloud-resume-api-gateway"
}
variable "api_gateway_region" {
  type        = string
  description = "The region in which to create/manage resources"
  default     = "us-east-1"
}
variable "api_gateway_account_id" {
  type        = string
  description = "The account ID in which to create/manage resources"
}
variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}
variable "lambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function"
}
variable "rest_api_stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
  default     = "prod"
}
variable "rest_api_resource_path_part" {
    type        = string
    description = "Path of resource the rest api uses"
    default     = "siteVisitorCount"
}