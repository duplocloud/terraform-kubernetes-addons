variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
  default     = null
}

variable "chart_version" {
  description = "The version of the Cert Manager Helm chart to install"
  type        = string
  default     = "2.12.0"
}

variable "values" {
  description = "Additional values to pass to the Cert Manager Helm chart"
  type        = map(any)
  default     = {}
}

variable "namespace" {
  description = "The namespace to install in, defaults to tenant namespace. NOTE: only one KEDA install per cluster is supported!"
  type        = string
  default     = null
}

variable "sets" {
  description = "Additional Helm sets to pass to the keda helm chart"
  type        = map(string)
  default     = {}
}
