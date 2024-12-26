/*
For Compute
output "public-ip-for-compute-instance" {
  value = oci_core_instance.oracle_linux_instance.public_ip
}
*/

output "cluster_id" {
  value = oci_containerengine_cluster.oke-cluster.id
}

output "region" {
  value = var.region
}