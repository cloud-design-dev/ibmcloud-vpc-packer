packer {
  required_plugins {
    ibmcloud = {
      version = ">=v2.2.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}

variable "ibm_api_key" {
  type = string
}

variable "ibm_region" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "starter-${local.timestamp}"
}

source "ibmcloud-vpc" "starter" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "${var.subnet_id}"
  resource_group_id  = "${var.resource_group_id}"
  security_group_id  = ""
  vsi_base_image_id  = "r038-6955ded7-4d13-40a8-b318-26d9323b12e3"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = ""

  image_name   = "${local.name}"
  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

build {
  name = "vpc-packer-builder"
  sources = [
    "source.ibmcloud-vpc.starter"
  ]

  provisioner "file" {
    source      = "./init.sh"
    destination = "/opt/init.sh"
  }

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    environment_vars = [
      "REGION=${var.ibm_region}",
      "PACKER_TEMPLATE=${local.name}"

    ]
    inline = [
      "chmod +x /opt/init.sh",
      "/opt/init.sh"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}



