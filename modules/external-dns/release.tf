resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  version    = var.chart_version
  namespace  = local.namespace
  values = [
    yamlencode(local.values)
  ]
  dynamic "set" {
    for_each = var.sets
    content {
      name  = set.key
      value = set.value
    }
  }
}
