## locals

locals {
  plan_id = data.duplocloud_tenant.current.plan_id
  cluster_name = data.duplocloud_plan.plan.kubernetes_config[0].name
}

## Datasources

# Get the plan info to get the cluster name
data "duplocloud_plan" "plan" {
  plan_id = local.plan_id
}


# Get tenant info, typically from the current workspace
data "duplocloud_tenant" "current" {
  name = var.tenant_name
}

# Get EKS credentials for helm provider
data "duplocloud_eks_credentials" "current" {
  plan_id = local.plan_id
}

# Get infrastructure to get the region for aws provider
data "duplocloud_infrastructure" "current" {
  infra_name = local.plan_id
}

# Get the route53 zone information
data "aws_route53_zone" "selected" {
  name = var.public_dns_domain
}

## Provider versions

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

## Provider configs

# Configure helm provider for chart deployment
provider "helm" {
  kubernetes {
    host                   = data.duplocloud_eks_credentials.current.endpoint
    cluster_ca_certificate = data.duplocloud_eks_credentials.current.ca_certificate_data
    token                  = data.duplocloud_eks_credentials.current.token
  }
}

# Configure aws provider for IAM role extension
provider "aws" {
  region = data.duplocloud_infrastructure.current.region
}

## Modules and resources

# Deploy external-dns module for managing Route53 records.  
# See https://github.com/kubernetes-sigs/external-dns/tree/master/docs/tutorials
module "external_dns" {
  source           = "../../modules/external-dns"
  tenant_name      = var.tenant_name
  dns_provider     = "aws"
  route53_zone_arn = data.aws_route53_zone.selected.arn
  values = {
    "aws.zone" : "public",
    "txtOwnerId" : local.cluster_name,
    "domainFilters[0]" : var.public_dns_domain
  }
}

## Variables
variable "public_dns_domain" {
  description = "The public DNS domain to manage"
  type        = string
  default     = "example.com"
}

variable "tenant_name" {
  description = "The name of the tenant"
  type        = string
  default     = "tf-tests"
}
