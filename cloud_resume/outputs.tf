output "website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.cloud_resume_site_bucket.id
}

output "bucket_endpoint" {
  description = "Bucket endpoint"
  value       = aws_s3_bucket_website_configuration.cloud_resume_site_bucket_website_configuration.website_endpoint
}

output "domain_name" {
  description = "Website endpoint"
  value       = var.domain_name
}

# output "visitor_counterLambda" {
#     value = module.visitorCounterLambda.visitor_counterLambdaName
# }

# output "visitor_counterLambdarn" {
#     value = module.visitorCounterLambda.visitor_counterLambdarn
# }

# output "rest_api_url" {
#     value = module.apiGateway.rest_api_url
# }