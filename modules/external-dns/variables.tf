variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "6.32.1"
}

variable "values" {
  description = "Additional values to pass to the Helm chart"
  type        = map(any)
  default     = {}
}

variable "service_account" {
  description = "The name of an existing service account.  If passed, module will not manage permissions"
  type        = string
  default     = null
}

variable "dns_provider" {
  description = "The DNS platform to use: aws, azure, google, etc.  See https://github.com/bitnami/charts/tree/main/bitnami/external-dns"
  type        = string
  default     = "aws"
}

variable "route53_zone_arn" {
  description = "The ARN of the Route53 zone to manage (AWS only)"
  type        = string
  default     = null

}
