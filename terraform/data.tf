data "ibm_is_image" "packer" {
  name       = var.ibm_image
  visibility = "private"
}

# data "linode_image" "packer" {
#   id = var.linode_image
# }

data "digitalocean_image" "packer" {
  name   = var.do_image
  source = "user"
}

data "ibm_is_vpc" "tor_lab" {
  name = var.lab_vpc
}

data "ibm_resource_group" "cde_lab" {
  name = var.resource_group
}

data "ibm_is_subnet" "backend_subnet" {
  name = var.instance_subnet
}

data "ibm_is_security_group" "backend_sg" {
  name = var.instance_security_group
}

data "ibm_is_ssh_key" "europa" {
  name = var.ssh_key
}

data "linode_sshkey" "europa" {
  label = "ryan_europa"
}

data "digitalocean_ssh_key" "europa" {
  name = "ryan@europa"
}