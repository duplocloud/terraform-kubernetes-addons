terraform {
  backend "s3" {
    workspace_key_prefix = "infra"
    key                  = "argocd"
    encrypt              = true
  }
  required_providers {
    duplocloud = {
      version = "~> 0.10.50"
      source  = "duplocloud/duplocloud"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.32.0"
    }
  }
}

provider "duplocloud" {

}

provider "aws" {
  region     = local.region
  access_key = data.duplocloud_admin_aws_credentials.this.access_key_id
  secret_key = data.duplocloud_admin_aws_credentials.this.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.this.session_token
}

provider "helm" {
  kubernetes {
    host                   = data.duplocloud_eks_credentials.this.endpoint
    cluster_ca_certificate = data.duplocloud_eks_credentials.this.ca_certificate_data
    token                  = data.duplocloud_eks_credentials.this.token
  }
}
