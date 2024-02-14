locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace              = local.namespace,
    service_account_name   = "${local.namespace}-edit-user",
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
