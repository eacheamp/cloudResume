terraform {
  backend "s3" {
    bucket  = "eacheampongterraform"
    key     = "cloud_resume"
    region  = "us-east-1"
    profile = "default"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                    = "us-east-1"
  shared_credentials_files  = ["~/.aws/credentials"]
  profile                   = "default"
}

# provider "cloudflare" {}

resource "aws_s3_bucket" "cloud_resume_site_bucket"{
  bucket    = var.bucket_name

  tags      = {
    use_case  = "Private bucket that holds web assets"
    Name      = var.bucket_name
  }
}

resource "aws_s3_bucket_website_configuration" "cloud_resume_site_bucket_website_configuration" {
  bucket      = aws_s3_bucket.cloud_resume_site_bucket.id

  index_document {
    suffix    = "resume_index.html"
  }

  error_document {
    key       = "error.html"
  }
}

resource "aws_s3_bucket_policy" "cloud_resume_site_bucket_policy" {
  bucket = aws_s3_bucket.cloud_resume_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource = [
          aws_s3_bucket.cloud_resume_site_bucket.arn,
          "${aaws_s3_bucket.cloud_resume_site_bucket.arn}/*",
        ]
      },
    ]
  })
}
resource "aws_s3_bucket_acl" "cloud_resume_bucket_acl" {
  bucket = aws_s3_bucket.cloud_resume_bucket.id
  acl    = "public-read"
}


resource "aws_s3_bucket_versioning" "cloud_resume_bucket_versioning" {
  bucket = aws_s3_bucket.cloud_resume_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.bucket_name}"
}

resource "aws_s3_bucket_acl" "www" {
  bucket = aws_s3_bucket.www.id

  acl = "private"
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = var.bucket_name
  }
}

# data "cloudflare_zones" "domain" {
#   filter {
#     name = var.site_domain
#   }
# }

# resource "cloudflare_record" "cloud_resume_cname" {
#   zone_id = var.zoneid
#   name    = var.bucket_name
#   value   = aws_s3_bucket_website_configuration.<cloud_resume_site_bucket_website_configuration>.website_endpoint
#   type    = "CNAME"

#   ttl     = 1
#   proxied = true
# }

# resource "cloudflare_record" "www" {
#   zone_id = var.zoneid
#   name    = "www"
#   value   = var.bucket_name
#   type    = "CNAME"

#   ttl     = 1
#   proxied = tru

# https://developer.hashicorp.com/terraform/tutorials/applications/cloudflare-static-website




