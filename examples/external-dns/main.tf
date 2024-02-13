## Datasources

# Get tenant info, typically from the current workspace
data "duplocloud_tenant" "current" {
  name = var.tenant_name
}

# Get EKS credentials for helm provider
data "duplocloud_eks_credentials" "this" {
  plan_id = data.duplocloud_tenant.current.plan_id
}

# Get infrastructure to get the region for aws provider
data "duplocloud_infrastructure" "current" {
  infra_name = data.duplocloud_tenant.current.plan_id
}

# Get the route53 zone information
data "aws_route53_zone" "selected" {
  name         = var.public_dns_domain
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
      version = ">= 0.10.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
  }
}

## Provider configs

# Configure helm provider for chart deployment
provider "helm" {
  kubernetes {
    host                   = data.duplocloud_eks_credentials.this.endpoint
    cluster_ca_certificate = data.duplocloud_eks_credentials.this.ca_certificate_data
    token                  = data.duplocloud_eks_credentials.this.token
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
  source = "../../modules/external-dns"
  tenant_name = var.tenant_name
  dns_provider = "aws"
  values = {
    "aws.zone": "public",
    "txtOwnerId": data.aws_route53_zone.selected.id
    "domainFilters[0]": var.public_dns_domain
  }
}

# Default duplo tenant role doesn't have Route53 permissions.  Add them here.
data "aws_iam_policy_document" "service_extension" {
  statement {
    sid = "externaldns"
    actions = [
      "route53:ChangeResourceRecordSets"
    ]
    resources = [
      data.aws_route53_zone.selected.arn
    ]
  }
  statement {
    sid = "externaldnsglobal"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets",
      "route53:ListTagsForResource"
    ]
    resources = [ "*" ]
  }
}

module "tenant-role" {
  source          = "github.com/duplocloud/terraform-duplocloud-components//modules/tenant-role-extension"
  tenant_name     = local.tenant_name
  iam_policy_json = data.aws_iam_policy_document.service_extension.json
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
