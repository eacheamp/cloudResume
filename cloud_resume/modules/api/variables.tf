variable "rest_api_name" {
    type        = string
    description = "Name of api gateway rest_api created"
    default     = "cloud-resume-api-gateway"
}

variable "rest_api_resource_path_part" {
    type        = string
    description = "Path of resource the rest api uses"
    default     = "siteVisitorCount"
}