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

/*output "generate_kubeconfig" {
  value = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.oke-cluster.id} --region ${var.region} --file ./kubeconfig --token-version 2.0.0"
}

output "kubectl_usage" {
  value = "export KUBECONFIG=./kubeconfig && kubectl get nodes"
}
*/