# If user hasn't passed a service account and is deploying to aws, we will add the IAM extension
# If no service account is passed in, we'll use the DuploCloud-managed SA.
locals {
  namespace       = "duploservices-${var.tenant_name}"
  infra_name      = data.duplocloud_tenant.this.plan_id
  service_account = var.service_account != null ? var.service_account : "${local.namespace}-edit-user"
  iam_extension   = var.service_account == null && var.dns_provider == "aws" ? 1 : 0
  context = {
    infra_name = local.infra_name,
    namespace  = local.namespace,
    sa_name    = local.service_account,
    sa_email   = ""
    provider   = var.dns_provider
    domain     = trimprefix(data.duplocloud_plan_settings.this.dns_setting[0].internal_dns_suffix, ".")
  }
  values = yamldecode(templatefile("${path.module}/values.yaml", local.context))
}

data "duplocloud_tenant" "this" {
  name = var.tenant_name
}

data "duplocloud_plan_settings" "this" {
  plan_id = local.infra_name
}

data "aws_route53_zone" "this" {
  count = local.iam_extension
  name  = local.context.domain
}
