data "ibm_resource_group" "project" {
  name = var.resource_group
}

data "ibm_is_ssh_key" "existing_ssh_key" {
  count = var.existing_ssh_key != "" ? 1 : 0
  name  = var.existing_ssh_key
}

