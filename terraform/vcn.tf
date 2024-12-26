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