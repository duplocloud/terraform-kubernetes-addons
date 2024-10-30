variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "1.15.0"
}

variable "service_account" {
  description = "The name of an existing service account.  If passed, module will not manage permissions"
  type        = string
  default     = null
  nullable    = true
}

variable "dns_provider" {
  description = "The DNS platform to use: aws, azure, google"
  type        = string
  default     = "aws"
}

variable "sets" {
  description = "Additional Helm values to pass to the Helm chart"
  type        = map(any)
  default     = {}
}

# https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md
variable "aws" {
  description = "AWS provider configuration"
  type        = object({
    match_parent = optional(bool, false)
    zone_type   = optional(string, null)
    cache_duration = optional(string, null)
    batch_change_size = optional(number, null)
    change_interval = optional(string, null)
  })
  default     = {}
}
