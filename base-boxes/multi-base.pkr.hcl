




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
}

variable "ibm_region" {
  type    = string
}


locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "ibmcloud-vpc" "ubuntu_base_image" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "02q7-fc0598ac-2e8b-4eb5-9349-868dc78d86d6"
  resource_group_id  = "6b6211f1af784e62874070340ee4b6be"
  security_group_id  = "r038-be438e0d-6bb1-41ee-8016-5e5ba2d53bef"
  vsi_base_image_id  = "r038-83d9d391-4449-4037-b64f-fdb642c2786c"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = "init.yml"

  image_name = "rt-ubuntu-${local.timestamp}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

source "ibmcloud-vpc" "rocky_base_image" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "02q7-fc0598ac-2e8b-4eb5-9349-868dc78d86d6"
  resource_group_id  = "6b6211f1af784e62874070340ee4b6be"
  security_group_id  = "r038-be438e0d-6bb1-41ee-8016-5e5ba2d53bef"
  vsi_base_image_id  = "r038-6c63d322-aa63-4f27-8c61-3133262bebdf"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = "init.yml"

  image_name = "rt-rocky-${local.timestamp}"
  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"

}

build {
  name = "vpc-packer-builder"
  sources = [
    "source.ibmcloud-vpc.ubuntu_base_image",
    "source.ibmcloud-vpc.rocky_base_image"
  ]

  provisioner "file" {
    only        = ["ibmcloud-vpc.rocky_base_image"]
    source      = "./rpm-test.sh"
    destination = "/opt/test.sh"
  }

  provisioner "file" {
    only        = ["ibmcloud-vpc.ubuntu_base_image"]
    source      = "./deb-test.sh"
    destination = "/opt/test.sh"
  }

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    environment_vars = [
      "REGION=${var.ibm_region}"
    ]
    inline = [
      "chmod +x /opt/test.sh",
      "/opt/test.sh"
    ]
  }

}

