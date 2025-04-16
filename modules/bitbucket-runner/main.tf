locals {
  namespace = "duploservices-${var.tenant_name}"
  labels = {
    "app.kubernetes.io/name" : "bitbucket-runner",
    "app.kubernetes.io/part-of" : "devops",
    "app.kubernetes.io/component" : "cicd"
  }
}

resource "duplocloud_k8_secret" "bitbucket_runner" {
  tenant_id   = var.tenant_id
  secret_name = var.name
  secret_type = "Opaque"
  secret_data = jsonencode(var.auth)
}

resource "kubernetes_deployment_v1" "bitbucket_runner" {
  metadata {
    name      = var.name
    namespace = local.namespace
    labels    = local.labels
    annotations = {
      "kubernetes.io/description" : "Bitbucket self hosted runner"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = local.labels
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        restart_policy = "Always"
        node_selector = length(var.node_selector) > 0 ? var.node_selector : {
          tenantname = local.namespace
        }


        # shared volumes
        volume {
          name = "tmp"
          empty_dir {}
        }
        volume {
          name = "docker-containers"
          empty_dir {}
        }
        volume {
          name = "var-run"
          empty_dir {}
        }

        # main bitbucket runner
        container {
          image = var.image
          name  = "runner"
          env {
            name  = "WORKING_DIRECTORY"
            value = "/tmp"
          }
          env {
            name  = "RUNTIME_PREREQUISITES_ENABLED"
            value = "true"
          }
          env_from {
            secret_ref {
              name = duplocloud_k8_secret.bitbucket_runner.secret_name
            }
          }
          volume_mount {
            name       = "docker-containers"
            mount_path = "/var/lib/docker/containers"
          }
          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }

        # docker in docker
        container {
          image = var.docker_image
          name  = "docker-in-docker"
          security_context {
            privileged = true
          }
          volume_mount {
            name       = "docker-containers"
            mount_path = "/var/lib/docker/containers"
          }
          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }
          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }
        }
      }
    }
  }
}
