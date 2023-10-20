variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

variable "tenant_id" {
  description = "The id of the tenant"
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart to install"
  type        = string
  default     = "0.54.0"
}

variable "name" {
  description = "The name of the Helm release"
  type        = string
  default     = "gitlab-runner"
}

variable "values" {
  description = "Additional values to pass to the Github Actions Controller Helm chart"
  type        = map(any)
  default     = {}
}

variable "runner_token" {
  description = "The Gitlab Runner registration token"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Gitlab Runner state"
  type        = string
  default     = "gitlab-runner-state"
}

variable "bucket_region" {
  description = "The region of the S3 bucket to store the Gitlab Runner state"
  type        = string
  default     = "us-east-1"
}
