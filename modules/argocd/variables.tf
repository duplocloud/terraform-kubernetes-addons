variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
}

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
