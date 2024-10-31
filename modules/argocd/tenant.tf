
resource "duplocloud_tenant_network_security_rule" "vpn_access" {
  tenant_id      = local.tenant_id
  source_address = local.vpn_cidr
  protocol       = "tcp"
  from_port      = 80
  to_port        = 443
  description    = "VPN to ArgoCD"
}
