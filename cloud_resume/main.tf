terraform {
  backend "s3" {
    bucket  = "eacheampongterraform"
    key     = "cloud_resume"
    region  = "us-east-1"
    profile = "default"
  }
}

# Configure the AWS Provider
provider "aws" {
  region                    = "us-east-1"
  shared_credentials_files  = ["~/.aws/credentials"]
  profile                   = "default"
}

provider "cloudflare" {
    api_token   = var.cloudflare_api_token
}

locals {
  bucket = "eacheampong.work"
}
resource "aws_s3_bucket" "cloud_resume_site_bucket"{
  bucket        = local.bucket
  force_destroy = true

  tags      = {
    site      = local.bucket
    use_case  = "Public bucket that holds web assets"
    Name      = var.domain_name
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

resource "aws_s3_bucket_ownership_controls" "cloud_resume_site_bucketownership" {
  bucket = aws_s3_bucket.cloud_resume_site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "cloud_resume_bucket_piblic_access_block" {
  bucket = aws_s3_bucket.cloud_resume_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "cloud_resume_bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.cloud_resume_site_bucketownership,
    aws_s3_bucket_public_access_block.cloud_resume_bucket_piblic_access_block]
  bucket = aws_s3_bucket.cloud_resume_site_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "cloud_resume_bucket_versioning" {
  bucket = aws_s3_bucket.cloud_resume_site_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "cloud_resume_site_bucket_policy" {
  bucket  = aws_s3_bucket.cloud_resume_site_bucket.id
  policy  = data.aws_iam_policy_document.allowedcloudresumepublic.json
}

data "aws_iam_policy_document" "allowedcloudresumepublic"{
  statement {
        sid         = "PublicReadGetObject"
        effect      = "Allow"
        principals  {
                    type = "AWS"
                    identifiers = ["*"]
        }
        actions     = ["s3:GetObject", "s3:GetObjectVersion"]
        resources   = [
          aws_s3_bucket.cloud_resume_site_bucket.arn,
          "${aws_s3_bucket.cloud_resume_site_bucket.arn}/*",
        ]
      }
}

resource "aws_s3_bucket" "www" {
  bucket  = "www.${var.domain_name}"
  tags      = {
    site      = local.bucket
    use_case  = "Redirtect bucket that holds web assets"
  }
}

resource "aws_s3_bucket_ownership_controls" "wwwbucketownership" {
  bucket = aws_s3_bucket.www.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "www" {
  depends_on = [aws_s3_bucket_ownership_controls.wwwbucketownership]
  bucket = aws_s3_bucket.www.id

  acl = "private"
}

resource "aws_s3_bucket_website_configuration" "www" {
  bucket = aws_s3_bucket.www.id

  redirect_all_requests_to {
    host_name = var.domain_name
  }
}

resource "cloudflare_record" "cloud_resume_cname" {
  zone_id = var.CloudFlareZoneID
  name    = var.domain_name
  value   = aws_s3_bucket_website_configuration.cloud_resume_site_bucket_website_configuration.website_endpoint
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

resource "cloudflare_record" "www" {
  zone_id = var.CloudFlareZoneID
  name    = "www"
  value   = var.domain_name
  type    = "CNAME"

  ttl     = 1
  proxied = true
}

resource "cloudflare_page_rule" "https_cloud_resume"{
  zone_id = var.CloudFlareZoneID
  target  = "*.${var.domain_name}/*"
  actions {
    always_use_https = true
  }
}