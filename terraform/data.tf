data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_cluster_kube_config" "kubeconfig" {
  cluster_id = oci_containerengine_cluster.oke-cluster.id
}