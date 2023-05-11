variable "region" {
    type    = string
    default = "us-east-1"
}

variable "domain_name" {
    type        = string
    description = "site domain of s3 hosted website"
}

variable "CloudFlareZoneID" {
    type        = string
    description = "CloudFlare Zone ID"
    sensitive   = true
}
variable "cloudflare_api_token" {
    type        = string
    description = "CloudFlare api token"
    sensitive   = true
}
