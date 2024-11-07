variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
  default     = "tf-tests"
}

variable "github_app" {
  description = "The credentials for github."
  type = object({
    url             = optional(string, "https://github.com/duplocloud")
    app_id          = optional(string, null)
    installation_id = optional(string, null)
    private_key     = optional(string, null)
    repository      = optional(list(string), [])
  })
  nullable = true
  default  = null
}

# Get tenant info, typically from the current workspace
data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_admin_aws_credentials" "this" {}

# Get EKS credentials for helm provider
data "duplocloud_eks_credentials" "this" {
  plan_id = data.duplocloud_tenant.this.plan_id
}

# Get infrastructure to get the region for aws provider
data "duplocloud_infrastructure" "this" {
  infra_name = data.duplocloud_tenant.this.plan_id
}

# Deploy external-dns module for managing Route53 records.  
# See https://github.com/kubernetes-sigs/external-dns/tree/master/docs/tutorials
module "argocd" {
  source      = "../../modules/argocd"
  tenant_name = var.tenant_name
  github_app = merge(var.github_app, {
    url = "https://github.com/duplocloud"
    repositories = [
      "argocd-example"
    ]
  })
}

output "release" {
  value = module.argocd
}
