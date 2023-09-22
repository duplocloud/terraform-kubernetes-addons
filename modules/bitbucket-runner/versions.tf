terraform {
  required_providers {
    duplocloud = {
      source  = "duplocloud/duplocloud"
      version = "~> 0.9.40"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
}
