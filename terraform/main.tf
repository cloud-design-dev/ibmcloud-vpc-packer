resource "ibm_is_instance" "rocky" {
  name                     = "rocky-packer-instance"
  image                    = data.ibm_is_image.rocky_base.id
  profile                  = "cx2-2x4"
  metadata_service_enabled = true
  resource_group           = data.ibm_resource_group.cde_lab.id

  boot_volume {
    name = "rocky-packer-boot-volume"
  }

  primary_network_interface {
    subnet            = data.ibm_is_subnet.backend_subnet.id
    security_groups   = [data.ibm_is_security_group.backend_sg.id]
    allow_ip_spoofing = false
  }

  vpc  = data.ibm_is_vpc.tor_lab.id
  zone = "ca-tor-1"
  keys = [data.ibm_is_ssh_key.regional.id]
  tags = ["owner:ryantiffany"]
}

resource "ibm_is_instance" "ubuntu" {
  name                     = "ubuntu-packer-instance"
  image                    = data.ibm_is_image.ubuntu_base.id
  profile                  = "cx2-2x4"
  metadata_service_enabled = true
  resource_group           = data.ibm_resource_group.cde_lab.id

  boot_volume {
    name = "ubuntu-packer-boot-volume"
  }

  primary_network_interface {
    subnet            = data.ibm_is_subnet.backend_subnet.id
    security_groups   = [data.ibm_is_security_group.backend_sg.id]
    allow_ip_spoofing = false
  }

  vpc  = data.ibm_is_vpc.tor_lab.id
  zone = "ca-tor-1"
  keys = [data.ibm_is_ssh_key.regional.id]
  tags = ["owner:ryantiffany"]
}
resource "ibm_is_instance" "debian" {
  name                     = "debian-packer-instance"
  image                    = data.ibm_is_image.debian_base.id
  profile                  = "cx2-2x4"
  metadata_service_enabled = true
  resource_group           = data.ibm_resource_group.cde_lab.id

  boot_volume {
    name = "debian-packer-boot-volume"
  }

  primary_network_interface {
    subnet            = data.ibm_is_subnet.backend_subnet.id
    security_groups   = [data.ibm_is_security_group.backend_sg.id]
    allow_ip_spoofing = false
  }

  vpc  = data.ibm_is_vpc.tor_lab.id
  zone = "ca-tor-1"
  keys = [data.ibm_is_ssh_key.regional.id]
  tags = ["owner:ryantiffany"]
}
