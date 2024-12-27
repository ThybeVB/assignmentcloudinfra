#VCN "Internal"
resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/16"
  compartment_id = var.compartment_id
  display_name   = "Reminder App VCN"
}

# NAT Gateway
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "NAT Gateway"
}

# NAT Route Table
resource "oci_core_route_table" "nat_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "NAT Route Table"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}

# VCN Internal Subnet
resource "oci_core_subnet" "worker_subnet" {
  vcn_id         = oci_core_vcn.internal.id
  cidr_block     = "172.16.1.0/24"
  compartment_id = var.compartment_id
  display_name   = "worker-subnet"
  route_table_id = oci_core_route_table.nat_route_table.id
  security_list_ids = [oci_core_security_list.worker_security_list.id]
  prohibit_public_ip_on_vnic = false # Allow public IP (Beter Bastion gebruiken voor security redenen)
}

# Security List
resource "oci_core_security_list" "worker_security_list" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "Worker Node Security List"

  egress_security_rules {
    destination      = "0.0.0.0/0"
    protocol         = "all"
  }

  ingress_security_rules {
    protocol = "6" # tcp
    source   = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }
}

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
