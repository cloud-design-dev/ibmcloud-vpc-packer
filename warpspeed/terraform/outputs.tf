output "instance_private_ip" {
  value = ibm_is_instance.warpspeed.primary_network_interface.0.primary_ipv4_address
}

output "instance_public_ip" {
  value = ibm_is_floating_ip.warpspeed.address
}
