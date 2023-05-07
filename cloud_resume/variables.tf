variable "region" {
    type    = string
    default = "us-east-1"
}

variable "bucket_name" {
    type    = string
    default = "ernestresume.eacheampong.io"
}

variable "zoneid" {
    type = string
    description = "CloudFlare Zone ID"
}