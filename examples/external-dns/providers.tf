terraform {
  required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.12.0"
    }
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }
  backend "s3" {
    workspace_key_prefix = "duplocloud/addons"
    key                  = "external-dns"
    encrypt              = true
  }
}

provider "helm" {
  kubernetes {
    host                   = data.duplocloud_eks_credentials.this.endpoint
    cluster_ca_certificate = data.duplocloud_eks_credentials.this.ca_certificate_data
    token                  = data.duplocloud_eks_credentials.this.token
  }
}

# Configure aws provider for IAM role extension
provider "aws" {
  region     = data.duplocloud_infrastructure.this.region
  access_key = data.duplocloud_admin_aws_credentials.this.access_key_id
  secret_key = data.duplocloud_admin_aws_credentials.this.secret_access_key
  token      = data.duplocloud_admin_aws_credentials.this.session_token
}
