locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace = local.namespace
    resource_class_token = var.resource_class_token
  }))
}

resource "helm_release" "circleci_agent" {
  name       = "container-agent"
  repository = "https://packagecloud.io/circleci/container-agent/helm"
  chart      = "container-agent"
  version    = var.chart_version
  namespace  = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
