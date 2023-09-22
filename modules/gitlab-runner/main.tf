locals {
  namespace = "duploservices-${var.tenant_name}"
  values = yamldecode(templatefile("${path.module}/values.yaml", {
    namespace = local.namespace
    release_name = var.name
  }))
}

resource "duplocloud_k8_secret" "gitlab_runner" {
  tenant_id = var.tenant_id
  secret_name = "gitlab-runner-registration"
  secret_type = "Opaque"
  secret_data = jsonencode({
    "runner-token" = var.runner_token
  })
}

resource "helm_release" "gitlab-runner" {
  name        = var.name
  repository  = "https://charts.gitlab.io"
  chart       = "gitlab-runner"
  version     = var.version
  namespace   = local.namespace
  values = [
    yamlencode(local.values),
    yamlencode(var.values)
  ]
}
