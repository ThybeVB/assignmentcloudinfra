# Cluster
resource "oci_containerengine_cluster" "oke-cluster" {
  compartment_id      = var.compartment_id
  kubernetes_version  = var.kubernetes_version
  name                = var.cluster_name
  vcn_id              = oci_core_vcn.internal.id
} 

# Node pool
resource "oci_containerengine_node_pool" "oke-node-pool" {
    cluster_id = oci_containerengine_cluster.oke-cluster.id
    compartment_id = oci_containerengine_cluster.oke-cluster.compartment_id
    kubernetes_version = oci_containerengine_cluster.oke-cluster.kubernetes_version
    name = "pool-1"
    node_config_details{
        placement_configs{
            availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
            subnet_id = oci_core_subnet.worker_subnet.id
        } 
        placement_configs{
            availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
            subnet_id = oci_core_subnet.worker_subnet.id
        }
         placement_configs{
            availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
            subnet_id = oci_core_subnet.worker_subnet.id
        }
        size = 3
    }
    node_shape = var.shape
    
    node_source_details {
         image_id = var.os_image_id
         source_type = "image"
    }
 
    node_metadata = {
      ssh_authorized_keys = file(var.public_key)
    }   
}
