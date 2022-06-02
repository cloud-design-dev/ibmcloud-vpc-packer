output "ibm_instance" {
  value = ibm_is_instance.ubuntu.primary_network_interface.0.primary_ipv4_address
}

output "do_instance" {
  value = digitalocean_droplet.ubuntu.ipv4_address
}

 output "linode_instance" {
  value = linode_instance.ubuntu.ipv4
}