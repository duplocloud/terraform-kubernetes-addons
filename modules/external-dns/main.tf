locals {
  namespace = "duploservices-${var.tenant_name}"
  # If no service account is passed in, we'll use the DuploCloud-managed SA.
  service_account = var.service_account != null ? var.service_account : "${local.namespace}-edit-user"
  # If user hasn't passed a service account and is deploying to aws, we will add the IAM extension
  iam_extension = var.service_account == null && var.dns_provider == "aws" ? 1 : 0
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace            = local.namespace,
    service_account_name = local.service_account,
    provider             = var.dns_provider
  }))
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "external-dns"
  version    = var.chart_version
  namespace  = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
