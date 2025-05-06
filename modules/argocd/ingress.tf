resource "duplocloud_k8_ingress" "this" {
  tenant_id          = local.tenant_id
  name               = "argocd"
  ingress_class_name = "alb"

  annotations = {
    "alb.ingress.kubernetes.io/backend-protocol" = "HTTP"

    "alb.ingress.kubernetes.io/conditions.argocd-server-grpc" = <<EOT
      [{"field":"http-header","httpHeaderConfig":{"httpHeaderName": "Content-Type", "values":["application/grpc"]}}]
    EOT

    "alb.ingress.kubernetes.io/group.name"         = "${local.infra_name}-argocd"
    "alb.ingress.kubernetes.io/load-balancer-name" = "${local.infra_name}-argocd"
    "alb.ingress.kubernetes.io/ssl-redirect"       = "443"
    "alb.ingress.kubernetes.io/target-type"        = "ip"
  }

  lbconfig {
    certificate_arn = local.cert_arn
    dns_prefix      = var.domain_prefix
    http_port       = 80
    https_port      = 443
    is_internal     = true
  }

  rule {
    host         = local.context.domain
    path         = "/"
    path_type    = "Prefix"
    port         = 80
    service_name = "argocd-server-grpc"
  }

  rule {
    host         = local.context.domain
    path         = "/"
    path_type    = "Prefix"
    port         = 80
    service_name = "argocd-server"
  }
}
