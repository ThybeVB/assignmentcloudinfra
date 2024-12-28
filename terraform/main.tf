terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.5"
    }
  }
}