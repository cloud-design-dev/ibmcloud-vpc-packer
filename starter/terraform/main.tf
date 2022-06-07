resource "ibm_is_instance" "packer" {
  name                     = "ibm-u20-packer"
  image                    = var.ibm_image
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
  vpc       = data.ibm_is_vpc.tor_lab.id
  zone      = "ca-tor-1"
  keys      = [data.ibm_is_ssh_key.europa.id]
  tags      = ["owner:ryantiffany", "packer_template_test"]
}
