resource "linode_instance" "ubuntu" {
  label           = "linode-u20-packer"
  image           =  var.linode_image
  region          = "us-central"
  type            = "g6-standard-1"
  authorized_keys = [data.linode_sshkey.europa.ssh_key]
  tags            = ["owner:ryantiffany", "packer_template_test"]
  swap_size       = 256
  private_ip      = true
}

resource "ibm_is_instance" "ubuntu" {
  name                     = "ibm-u20-packer"
  image                    = data.ibm_is_image.packer.id
  profile                  = "cx2-2x4"
  metadata_service_enabled = true
  resource_group           = data.ibm_resource_group.cde_lab.id

  boot_volume {
    name = "ibm-u20-boot-volume"
  }

  primary_network_interface {
    subnet            = data.ibm_is_subnet.backend_subnet.id
    security_groups   = [data.ibm_is_security_group.backend_sg.id]
    allow_ip_spoofing = false
  }

  user_data = file("./ibm.sh")
  vpc  = data.ibm_is_vpc.tor_lab.id
  zone = "ca-tor-1"
  keys = [data.ibm_is_ssh_key.europa.id]
  tags = ["owner:ryantiffany", "packer_template_test"]
}

resource "digitalocean_droplet" "ubuntu" {
  image    = data.digitalocean_image.packer.id
  name     = "do-u20"
  region   = "nyc3"
  size     = "s-1vcpu-2gb"
  ssh_keys = [data.digitalocean_ssh_key.europa.id]
  tags     = ["owner:ryantiffany", "packer_template_test"]
  user_data = file("./do.sh")
}