# IBM Cloud VPC Packer Examples

## Packer Overview

## Configuration Blocks

### Packer block

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

You can pass variables to the build process in several ways:

- Environment Variables
- Manually configured in packer file 
- Provided via CLI `-var` and `-var-file` options

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

The top-level source block defines reusable builder configuration blocks. The first label — `ibmcloud-vpc` here — is the builder type.

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

The build block defines what builders are started, how to provision them and if necessary what to do with their artifacts using post-process.

```hcl
build {
  name = "vpc-packer-builder"
  sources = [
    "source.ibmcloud-vpc.ubuntu_base_image",
  ]
}
```

### Provisioner Blocks

Provisioners use builtin and third-party software to install and configure the machine image after booting. Provisioners prepare the system for use by performing common tasks such as:

- Update kernel modules
- Add system users
- Deploy and configure software

While there are a number of `provisioners` supported by Packer, the most common are: [File](https://www.packer.io/docs/provisioners/file), [Shell](https://www.packer.io/docs/provisioners/shell), [Shell (local)](https://www.packer.io/docs/provisioners/shell-local), and [PowerShell](https://www.packer.io/docs/provisioners/powershell).

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
```

## Packer Build Flow

When we initiate a `packer build` several things happen:

- A new temporary SSH Key is created and added to the VPC Region
- A new compute instance is created with the temporary SSH key injected
- All `user-data` and `provisioners` are run on the instance
- The compute instance is stopped and a new custom image template is created from the stopped machine

Once the image template is marked as `available`, the compute instance and SSH keys that were created are removed from the account.

```sh
packer validate example.pkr.hcl
packer build example.pkr.hcl
```

## Todo 

- [ ] CentOS instance with cloud-init that adds packages, see if that works 
- [ ] Create packer config file that includes Ansible playbook to install Apache2
- [ ] Windows instance with winrm (need powershell script)