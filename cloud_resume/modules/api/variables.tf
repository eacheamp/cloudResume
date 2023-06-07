variable "fetch_rest_api_name" {
    type        = string
    description = "Name of api gateway rest_api to fetch data from dynamo table"
    default     = "cloud-resume-api-gateway-fetch"
}
variable "update_rest_api_name" {
    type        = string
    description = "Name of api gateway rest_api to update data from dynamo table"
    default     = "cloud-resume-api-gateway-update"
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
variable "getlambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}
variable "getlambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function"
}
variable "putlambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}
variable "putlambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function"
}
variable "rest_api_stage_name" {
  type        = string
  description = "The name of the API Gateway stage"
  default     = "prod"
}
variable "fetch_rest_api_resource_path_part" {
    type        = string
    description = "Path of resource the get rest api uses"
    default     = "getsitestat"
}
variable "update_rest_api_resource_path_part" {
    type        = string
    description = "Path of resource the put rest api uses"
    default     = "postsitestat"
}