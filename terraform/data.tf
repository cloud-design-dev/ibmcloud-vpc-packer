data "ibm_is_image" "ubuntu_base" {
  name       = var.ubuntu_image
  visibility = "private"
}

data "ibm_is_image" "rocky_base" {
  name       = var.rocky_image
  visibility = "private"
}

data "ibm_is_image" "debian_base" {
  name       = var.debian_image
  visibility = "private"
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

data "ibm_is_ssh_key" "regional" {
  name = var.ssh_key
}

