variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}

variable "chart_version" {
  description = "The version of the Cert Manager Helm chart to install"
  type = string
  default = "2.12.0"
}

variable "values" {
  description = "Additional values to pass to the Cert Manager Helm chart"
  type = map
  default = {}
}
