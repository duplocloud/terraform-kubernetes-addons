output "url" {
  description = "The url to use for ArgoCD"
  value = "https://${local.context.domain}"
}
