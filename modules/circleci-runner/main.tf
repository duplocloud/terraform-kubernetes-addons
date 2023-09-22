locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace = local.namespace
  }))
}

resource "helm_release" "github_actions_controller" {
  name        = "container-agent"
  repository  = "https://packagecloud.io/circleci/container-agent/helm"
  chart       = "container-agent"
  version     = var.version
  namespace   = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
