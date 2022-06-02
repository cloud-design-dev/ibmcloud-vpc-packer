packer {
  required_plugins {
    ibmcloud = {
      version = ">=v2.2.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}

variable "ibm_api_key" {
  type    = string
  default = "${env("IBMCLOUD_API_KEY")}"
}

variable "ibm_region" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "ibmcloud-vpc" "starter" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "02q7-0f27fd0f-e037-4b7a-9e6f-2cd138744191"
  resource_group_id  = "6b6211f1af784e62874070340ee4b6be"
  security_group_id  = "r038-be438e0d-6bb1-41ee-8016-5e5ba2d53bef"
  vsi_base_image_id  = "r038-6955ded7-4d13-40a8-b318-26d9323b12e3"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = "init.yml"

  image_name   = "rt-starter-${local.timestamp}"
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

  provisioner "shell" {
    inline = ["echo '${build.SSHPrivateKey}' > /tmp/packer-session.pem"]
  }

  provisioner "shell-local" {
    execute_command = ["bash", "-c", "{{.Vars}} {{.Script}}"]
    inline = ["echo '${build.SSHPrivateKey}'"]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}



