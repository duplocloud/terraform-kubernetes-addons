output "url" {
  description = "The url to use for ArgoCD"
  value = "https://${local.context.domain}"
}

# output "sg" {
#   value = data.duplocloud_infrastructure.this.security_groups
# }

output "tenant_id" {
  value = local.tenant_id
}

output "infra_name" {
  value = local.infra_name
}
