output "bucket_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.cloud_resume_site_bucket.id
}


# *** To Do **
output "bucket_endpoint" {
  description = "Bucket endpoint"
  value       = aws_s3_bucket.cloud_resume_site_bucket.website_endpoint
}

output "domain_name" {
  description = "Website endpoint"
  value       = var.site_domain
}