locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace = local.namespace
  }))
}

resource "helm_release" "github_actions_controller" {
  name        = "github-actions-controller"
  repository  = "https://actions-runner-controller.github.io/actions-runner-controller"
  chart       = "github-actions-controller"
  version     = var.version
  namespace   = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
