locals {
  infra_name  = data.duplocloud_tenant.this.plan_id
  tenant_id   = data.duplocloud_tenant.this.id
  namespace   = "duploservices-${var.tenant_name}"
  region      = data.duplocloud_infrastructure.this.region
  vpc_sg      = join(",", [for obj in data.duplocloud_infrastructure.this.security_groups : obj.id])
  vpn_cidr    = "${data.aws_cloudformation_stack.openvpn.outputs["PrivateIp"]}/32"
  values      = yamldecode(templatefile("${path.module}/values.yaml", local.context))
  context = {
    workspace       = local.infra_name
    namespace       = local.namespace
    domain          = "${var.domain_prefix}${data.duplocloud_plan_settings.this.dns_setting[0].internal_dns_suffix}"
    security_groups = "${data.aws_security_group.alb.id},${local.vpc_sg}"
    subnets         = join(",", data.duplocloud_tenant_internal_subnets.this.subnet_ids)
    cert_arn        = var.cert_name != null ? data.duplocloud_plan_certificate.this[0].arn : data.duplocloud_plan_certificates.this[0].certificates[0].arn
    google_oauth    = var.google_oauth
    github_app      = var.github_app
  }
}

data "duplocloud_admin_aws_credentials" "this" {}

data "duplocloud_eks_credentials" "this" {
  plan_id = local.infra_name
}

data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_infrastructure" "this" {
  infra_name = local.infra_name
}

data "duplocloud_plan_settings" "this" {
  plan_id = local.infra_name
}

data "duplocloud_tenant_internal_subnets" "this" {
  tenant_id = local.tenant_id
}

data "aws_security_group" "alb" {
  name = "${local.namespace}-alb"
}

# so we can get the vpn cidr
data "aws_cloudformation_stack" "openvpn" {
  name = "duplo-openvpn-v1"
}

data "duplocloud_plan_certificate" "this" {
  count   = var.cert_name != null ? 1 : 0
  plan_id = local.infra_name
  name    = var.cert_name
}

data "duplocloud_plan_certificates" "this" {
  count   = var.cert_name == null ? 1 : 0
  plan_id = local.infra_name
}
