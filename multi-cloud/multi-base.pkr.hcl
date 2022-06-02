packer {
  required_plugins {
    ibmcloud = {
      version = ">=v2.2.0"
      source  = "github.com/IBM/ibmcloud"
    }
    digitalocean = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}

variable "ibm_api_key" {
  description = "IBM Cloud API key."
  type        = string
}

variable "ibm_region" {
  description = "IBM Cloud Region where image will be created."
  type        = string
}

variable "do_api_token" {
  description = "Digital Ocean API Token."
  type        = string
}

variable "linode_token" {
  description = "Linode API Token."
  type        = string
}

variable "logging_key" {
  description = "IBM Cloud Logging Agent Key."
  type        = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  name      = "packer-${local.timestamp}"
}

source "linode" "ubuntu_20" {
  image             = "linode/ubuntu20.04"
  image_description = "linode-ubuntu-${local.timestamp} image"
  image_label       = "linode-ubuntu-${local.timestamp}"
  instance_label    = "l-${local.name}"
  instance_type     = "g6-nanode-1"
  linode_token      = "${var.linode_token}"
  region            = "us-east"
  ssh_username      = "root"
}

source "digitalocean" "ubuntu_20" {
  api_token      = "${var.do_api_token}"
  image          = "ubuntu-20-04-x64"
  snapshot_name  = "d-${local.name}"
  region         = "nyc3"
  size           = "s-1vcpu-2gb"
  communicator   = "ssh"
  ssh_username   = "root"
  ssh_port       = 22
  ssh_timeout    = "15m"
  user_data_file = "init.yml"
}

source "ibmcloud-vpc" "ubuntu_20" {
  api_key = "${var.ibm_api_key}"
  region  = "${var.ibm_region}"

  subnet_id          = "02q7-0f27fd0f-e037-4b7a-9e6f-2cd138744191"
  resource_group_id  = "6b6211f1af784e62874070340ee4b6be"
  security_group_id  = "r038-be438e0d-6bb1-41ee-8016-5e5ba2d53bef"
  vsi_base_image_id  = "r038-6955ded7-4d13-40a8-b318-26d9323b12e3"
  vsi_profile        = "cx2-2x4"
  vsi_interface      = "public"
  vsi_user_data_file = "init.yml"

  image_name = "i-${local.name}"

  communicator = "ssh"
  ssh_username = "root"
  ssh_port     = 22
  ssh_timeout  = "15m"

  timeout = "30m"
}

build {
  sources = [
    "source.ibmcloud-vpc.ubuntu_20",
    "source.linode.ubuntu_20",
    "source.digitalocean.ubuntu_20",
  ]

  provisioner "ansible" {
    playbook_file = "./playbooks/update.yml"
  }

  provisioner "ansible" {
    playbook_file   = "./playbooks/logging.yml"
    extra_arguments = ["--extra-vars", "logdna_ingestion_key=${var.logging_key}", "--extra-vars", "region=${var.ibm_region}"]
  }

}

