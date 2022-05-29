# IBM Cloud VPC Packer Examples

## Provider Plugin

- Point to source of provider scripts 
- Go VPC SDK 

## Variables

- Using Environment variables

## Source 

- The top-level source block defines reusable builder configuration blocks

The first label — `ibmcloud-vpc` here — is the builder type.

## Build 

- The build block defines what builders are started, how to provision them and if necessary what to do with their artifacts using post-process.

## Provisioners 

- Provisioners use builtin and third-party software to install and configure the machine image after booting. Provisioners prepare the system for use:


## Process

```
Start -> Packer Build -> Create scripts -> Create Packer SSH Key for provisioner (scripts) -> Create VPC instance, run provisioners -> Stop Instance -> Create Image -> Destroy instance -> Delete Packer SSH Key -> Return volume name and ID
```

## Todo 

- [ ] CentOS instance with cloud-init that adds packages, see if that works 
- [ ] Create packer config file that includes Ansible playbook to install Apache2
- [ ] Windows instance with winrm (need powershell script)