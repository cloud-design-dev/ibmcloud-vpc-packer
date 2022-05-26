variable "name" {
  default = "pkr-test"
}

variable "base_image" {
  default = "hashistack-20220526185540"
}

variable "tor_lab_vpc" {
  default = "base-lab-vpc"
}

variable "instance_subnet" {
  default = "frontend-zone-1-subnet"
}

variable "instance_security_group" {
  default = "base-lab-vpc-frontend-sg"
}

variable "resource_group" {
  default = "2022-cde-lab"
}

variable "europa_ssh_key" {
  default = "europa-ca-tor"
}

variable "region" {
  default = "ca-tor"
}
