variable "region" {
    type    = string
    default = "us-east-1"
}

variable "bucket_name" {
    type        = string
    description = "site domain of s3 hosted website"
}

variable "CloudFlareZoneID" {
    type        = string
    description = "CloudFlare Zone ID"
}
# variable "apitoken" {
#     type = string
#     description = "CloudFlare API Token"
# }