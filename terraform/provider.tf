provider "oci" {
  region              = var.region
  auth                = "SecurityToken"
  config_file_profile = "permanent"
}

provider "kubernetes" {
  config_path = local_file.kubeconfig_file.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig_file.filename
  }
}