output "ubuntu_instance" {
  value = ibm_is_instance.ubuntu.primary_network_interface.0.primary_ipv4_address
}

output "rocky_instance" {
  value = ibm_is_instance.rocky.primary_network_interface.0.primary_ipv4_address
}

output "debian_instance" {
  value = ibm_is_instance.debian.primary_network_interface.0.primary_ipv4_address
}