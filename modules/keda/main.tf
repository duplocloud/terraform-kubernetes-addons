locals {
  tenant_name = var.tenant_name != null ? "duploservices-${var.tenant_name}" : null
  # If user passes a namespace, use that, otherwise default to tenant namespace
  namespace = var.namespace != null ? var.namespace : local.tenant_name
}

resource "helm_release" "kedacore" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = var.chart_version
  namespace  = local.namespace
  values = [
    yamlencode(var.values)
  ]
  # If the namespace is a tenant namenamespace, add a nodeSelector. Otherwise assume a system namespace
  dynamic "set" {
    for_each = local.namespace == local.tenant_name ? merge(var.sets, { "nodeSelector.tenantname" : local.tenant_name }) : var.sets
    content {
      name  = set.key
      value = set.value
    }
  }
}
