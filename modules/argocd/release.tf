resource "helm_release" "release" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.6.12"
  namespace        = local.context.namespace
  # create_namespace = true
  wait             = true
  values = [
    yamlencode(local.values)
  ]
}
