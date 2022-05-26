data "ibm_is_image" "packer_base" {
  name       = var.base_image
  visibility = "private"
}

data "ibm_is_vpc" "tor_lab" {
  name = var.tor_lab_vpc
}

data "ibm_resource_group" "cde_lab" {
  name = var.resource_group
}

data "ibm_is_subnet" "frontend_subnet" {
  name = var.instance_subnet
}

data "ibm_is_security_group" "frontend_sg" {
  name = var.instance_security_group
}

data "ibm_is_ssh_key" "tor_key" {
  name = var.europa_ssh_key
}

