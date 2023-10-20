terraform {
  required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = ">= 0.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

provider "duplocloud" {

}

provider "helm" {
  kubernetes {
    host                   = data.duplocloud_eks_credentials.current.endpoint
    cluster_ca_certificate = data.duplocloud_eks_credentials.current.ca_certificate_data
    token                  = data.duplocloud_eks_credentials.current.token
  }
}

variable "tenant_name" {
  type    = string
  default = "tf-tests"
}

data "duplocloud_tenant" "current" {
  name = var.tenant_name
}

data "duplocloud_eks_credentials" "current" {
  plan_id = data.duplocloud_tenant.current.plan_id
}

module "cert_manager" {
  source      = "../../modules/bitbucket-runner"
  tenant_name = data.duplocloud_tenant.current.name
  tenant_id   = data.duplocloud_tenant.current.id
  auth = {
    ACCOUNT_UUID        = ""
    REPOSITORY_UUID     = ""
    RUNNER_UUID         = ""
    OAUTH_CLIENT_ID     = ""
    OAUTH_CLIENT_SECRET = ""
  }
}
