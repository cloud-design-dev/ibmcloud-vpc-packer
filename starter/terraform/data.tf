# data "ibm_is_image" "packer" {
#   name       = var.ibm_image
#   visibility = "private"
# }

# data "digitalocean_image" "packer" {
#   name   = var.do_image
#   source = "user"
# }

data "local_file" "packer_manifest" {
  filename = "../manifest.json"
}

data "ibm_is_vpc" "tor_lab" {
  name = var.lab_vpc
}

data "ibm_resource_group" "cde_lab" {
  name = "2022-cde-lab"
}

data "ibm_is_subnet" "backend_subnet" {
  name = "backend-zone-1-subnet"
}

data "ibm_is_security_group" "backend_sg" {
  name = "base-lab-vpc-backend-sg"
}

data "ibm_is_ssh_key" "europa" {
  name = "europa-ca-tor"
}

# data "linode_sshkey" "europa" {
#   label = "ryan_europa"
# }

# data "digitalocean_ssh_key" "europa" {
#   name = "ryan@europa"
# }