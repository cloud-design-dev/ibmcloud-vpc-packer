# Getting Started with Packer on IBM Cloud

## Packer Overview

[Packer](https://www.packer.io) is an open-source tool from Hashicorp that helps you automate the process creating machine images. In this context, a machine image is a piece of immutible infrastructure that contains a preconfigured operating system and installed software/applications. Packer allows you to build images across multiple cloud and compute providers and on-prem infrastructure.

## Mutable vs Immutable infrastructure

In traditional deployment scenarios, our developers write some code, our ops team deploys the needed infrastructure, and then has to:

- Patch the kernel
- Add system packages or third party binaries
- Add users and set up group-level access
- Copy application code to the server

The workflow looks like this:

![Traditional flow](images/traditional-flow.png)

With Packer we can swap those last 2 actions so that the machines we provision are up-to-date, pre-baked, and ready for production.  

![Packer flow](images/packer-flow.png)

## The Packer Template

A Packer template is split in to many configuration `blocks` that determine how the machine image is created.

![Packer template overview](images/packer-config.png)

### Packer block

The [Packer](https://www.packer.io/docs/templates/hcl_templates/blocks/packer) block is used to control the behavior of Packer itself. In most cases this is you would set version constraints or declare all of the plugins required for the machine image to be created. 

```hcl
packer {
  required_plugins {
    ibmcloud = {
      version = ">=v2.2.0"
      source  = "github.com/IBM/ibmcloud"
    }
  }
}
```

### Variables

The [Variables](https://www.packer.io/docs/templates/hcl_templates/blocks/variable) block allows you to define variables within your Packer configuration.

You can pass variables to the build process in several ways:

- Environment Variables
- Manually configured in the packer file 
- Via the CLI with the `-var` and `-var-file` options

```hcl
variable "ibm_api_key" {
  type    = string
  default = "${env("IBMCLOUD_API_KEY")}"
}

variable "ibm_region" {
  type    = string
  default = "ca-tor"
}

variable "another_secret_one" {
    type = string
}
```

### Source Blocks

The [Source](https://www.packer.io/docs/templates/hcl_templates/blocks/source) block defines an image builder plugin. The first label — `ibmcloud-vpc` here — is the builder plugin used to create our machine image.

```hcl
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
```

### Build Blocks

The [Build](https://www.packer.io/docs/templates/hcl_templates/blocks/build) block defines what builders are started, how to provision them and if necessary what to do with their artifacts using post-process.

```hcl
build {
  name = "vpc-packer-builder"
  sources = [
    "source.ibmcloud-vpc.ubuntu_base_image",
    "source.ibmcloud-vpc.rocky_base_image",
    "source.ibmcloud-vpc.debian_base_image"
  ]
}
```

### Provisioner Blocks

[Provisioners](https://www.packer.io/docs/templates/hcl_templates/blocks/build/provisioner) use builtin and third-party software to install and configure the machine image after booting (configure before deploy). While there are a number of `provisioners` supported by Packer, the most common are: [File](https://www.packer.io/docs/provisioners/file), [Shell](https://www.packer.io/docs/provisioners/shell), [Ansible](https://www.packer.io/plugins/provisioners/ansible/ansible), and [PowerShell](https://www.packer.io/docs/provisioners/powershell).

```hcl
  provisioner "file" {
    source      = "./hashi.sh"
    destination = "/opt/hashi.sh"
  }

  provisioner "shell" {
    execute_command = "{{.Vars}} bash '{{.Path}}'"
    environment_vars = [
      "REGION=${var.ibm_region}",
      "LOGDNA_KEY=${var.logging_key}"

    ]
    inline = [
      "chmod +x /opt/hashi.sh",
      "/opt/hashi.sh"
    ]
  }

  provisioner "ansible" {
    playbook_file    = "./monitoring.yml"
    extra_arguments = ["--extra-vars", "packer_template=${var.logging_key}", "--extra-vars", "region=${var.ibm_region}"]
  }
```

## Packer Build Flow

When we initiate a `packer build` several things happen:

- A new temporary SSH Key is created and added to the VPC Region.
- A new compute instance is created with the temporary SSH key injected.
- All declared provisioners are run. Ex: shell scripts, ansible playbooks, etc.
- The compute instance is rebooted and then stopped.
- An image is taken from the stopped compute instance.
- All declared post-processors are executed.
- Once the image template is marked as `available`, the compute instance and SSH keys that were created are deleted.

---

![Packer flow in IBM Cloud](images/ibm-packer-flow.png)

## Let's see some code!