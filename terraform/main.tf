resource "ibm_is_instance" "packer" {
  name                     = "${var.name}-instance"
  image                    = data.ibm_is_image.packer_base.id
  profile                  = "cx2-2x4"
  metadata_service_enabled = true
  resource_group           = data.ibm_resource_group.cde_lab.id

  boot_volume {
    name = "${var.name}-boot-volume"
  }

  primary_network_interface {
    subnet            = data.ibm_is_subnet.frontend_subnet.id
    security_groups   = [data.ibm_is_security_group.frontend_sg.id]
    allow_ip_spoofing = true
  }

  vpc  = data.ibm_is_vpc.tor_lab.id
  zone = "ca-tor-1"
  keys = [data.ibm_is_ssh_key.tor_key.id]
  tags = ["owner:ryantiffany"]
}

resource "ibm_is_floating_ip" "packer" {
  name           = "${var.name}-floating-ip"
  resource_group = data.ibm_resource_group.cde_lab.id
  target         = ibm_is_instance.packer.primary_network_interface[0].id
}