variable "s3_bucket" {
  type        = string
  description = "The name of the S3 bucket to store the Lambda function code"
  default     = "terraform-api-gateway-lambda-bucket-eacheampong" // must be unique - change this to something unique
}