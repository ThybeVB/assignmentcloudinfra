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
  config_file_profile = "permanent"
}
