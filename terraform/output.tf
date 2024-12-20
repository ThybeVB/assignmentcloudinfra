output "public-ip-for-compute-instance" {
  value = oci_core_instance.oracle_linux_instance.public_ip
}
