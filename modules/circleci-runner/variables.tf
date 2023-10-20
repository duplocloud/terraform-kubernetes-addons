variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "101.0.8"
}

variable "values" {
  description = "Additional values to pass to the container-agent Helm chart"
  type        = map(any)
  default     = {}
}

variable "resource_class_token" {
  description = "The resource class token to use for the CircleCI runner"
  type        = string
}
