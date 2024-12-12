terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
    }
  }
}

provider "oci" {
  region              = "eu-amsterdam-1"
  auth                = "SecurityToken"
  config_file_profile = "profile"
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "My internal VCN"
}

variable "compartment_id" {
  type      = string
  sensitive = true
}