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

variable "dns_provider" {
  description = "The DNS provider to use. See https://github.com/bitnami/charts/blob/main/bitnami/external-dns/values.yaml"
  type        = string
  default     = "aws"
}

