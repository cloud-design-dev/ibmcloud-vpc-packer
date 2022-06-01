variable "ubuntu_image" {
  default = ""
}

variable "rocky_image" {
  default = ""
}

variable "debian_image" {
  default = ""
}

variable "lab_vpc" {
  default = "base-lab-vpc"
}

variable "instance_subnet" {
  default = "backend-zone-1-subnet"
}

variable "instance_security_group" {
  default = "base-lab-vpc-backend-sg"
}

variable "resource_group" {
  default = "2022-cde-lab"
}

variable "ssh_key" {
  default = "europa-ca-tor"
}

variable "region" {
  default = "ca-tor"
}
