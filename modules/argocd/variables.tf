
variable "domain_prefix" {
  type    = string
  default = "argocd"
}

variable "cert_name" {
  type        = string
  description = "Optional name or the first one is chosen"
  nullable    = true
  default     = null
}

variable "asg" {
  type = object({
    az_list            = optional(list(string), ["a", "b"])
    capacity           = optional(string, "t3.medium")
    instance_count     = optional(number, 1)
    min_instance_count = optional(number, 0)
    max_instance_count = optional(number, 10)
    os_disk_size       = optional(number, 40)
  })
  default     = {}
  description = "ASG for the data apps"
}

variable "google_oauth" {
  description = "The credentials for google oauth."
  type = object({
    client_id     = optional(string, null)
    client_secret = optional(string, null)
  })
  nullable = true
  default  = null
}

variable "github_app" {
  description = "The credentials for github."
  type = object({
    url             = optional(string, "https://github.com/duplocloud")
    app_id          = optional(string, null)
    installation_id = optional(string, null)
    private_key     = optional(string, null)
  })
  nullable = true
  default  = null
}
