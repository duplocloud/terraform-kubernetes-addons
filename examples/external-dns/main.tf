variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
  default     = "tf-tests"
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
module "external_dns" {
  source       = "../../modules/external-dns"
  tenant_name  = var.tenant_name
  dns_provider = "aws"
}

output "release" {
  value = module.external_dns
}
