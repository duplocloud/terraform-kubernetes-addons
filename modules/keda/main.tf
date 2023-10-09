locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace = local.namespace
  }))
}

resource "helm_release" "kedacore" {
  name        = "keda"
  repository  = "https://kedacore.github.io/charts"
  chart       = "keda"
  version     = var.version
  namespace   = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
