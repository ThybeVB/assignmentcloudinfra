resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = var.compartment_id
  display_name   = "Reminder App VCN"
}

resource "oci_core_instance" "oracle_linux_instance" {
  availability_domain = var.availability_domain
  compartment_id      = var.compartment_id
  shape               = var.shape

  display_name = "Oracle-Linux-Instance"

  source_details {
    source_id   = var.os_image_id
    source_type = "image"
  }

  create_vnic_details {
    subnet_id = var.public_subnet_id
  }

  metadata = {
    ssh_authorized_keys = file(var.public_key)
  }
}