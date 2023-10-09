variable "tenant_name" {
  description = "The name of the tenant"
  type = string
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type = string
  default = "0.54.0"
}

variable "name" {
  description = "The name of the Helm release"
  type = string
  default = "gitlab-runner"
}

variable "values" {
  description = "Additional values to pass to the Github Actions Controller Helm chart"
  type = map
  default = {}
}

variable "runner_token" {
  description = "The Gitlab Runner registration token"
  type = string
}
