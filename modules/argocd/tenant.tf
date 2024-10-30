resource "duplocloud_tenant" "this" {
  account_name       = local.tenant_name
  plan_id            = local.infra_name
  allow_deletion     = true
  wait_until_deleted = true
  timeouts {}
}

resource "duplocloud_tenant_config" "this" {
  tenant_id = local.tenant_id
  setting {
    key   = "delete_protection"
    value = "true"
  }
}

resource "duplocloud_tenant_network_security_rule" "vpn_access" {
  tenant_id      = local.tenant_id
  source_address = local.vpn_cidr
  protocol       = "tcp"
  from_port      = 80
  to_port        = 443
  description    = "VPN to ArgoCD"
}
