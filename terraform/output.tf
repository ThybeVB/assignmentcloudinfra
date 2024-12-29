output "cluster_id" {
  value = oci_containerengine_cluster.oke-cluster.id
}

output "region" {
  value = var.region
}

output "kubeconfig" {
  value     = data.oci_containerengine_cluster_kube_config.kubeconfig.content
}

output "worker_subnet_id" {
  value = oci_core_subnet.worker_subnet.id
}

resource "local_file" "kubeconfig_file" {
  content  = data.oci_containerengine_cluster_kube_config.kubeconfig.content
  filename = "${path.module}/kubeconfig.yaml"
}