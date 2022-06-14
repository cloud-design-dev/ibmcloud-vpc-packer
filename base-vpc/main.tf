locals {
  ssh_key_ids          = var.existing_ssh_key != "" ? [data.ibm_is_ssh_key.existing_ssh_key.0.id, ibm_is_ssh_key.generated_key.id] : [ibm_is_ssh_key.generated_key.id]
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "generated_key" {
  name           = "${var.name}-${var.region}-key"
  public_key     = tls_private_key.ssh.public_key_openssh
  resource_group = data.ibm_resource_group.project.id
  tags           = concat(var.tags, ["region:${var.region}", "project:${var.name}")
}

module "vpc" {
  source = "./vpc"
  name = var.name
  resource_group = data.ibm_resource_group.project.id
  zone = data.ibm_is_zones.regional.zones[0]
  tags = concat(var.tags, ["region:${var.region}", "project:${var.name}")
}

module "observability" {
  source = "./observability"
  name = var.name
  resource_group = data.ibm_resource_group.project.id
  region = var.region
  tags = concat(var.tags, ["region:${var.region}", "project:${var.name}")
}

module "object_storage" {
  source = "./object_storage"
  name = var.name
  resource_group = data.ibm_resource_group.project.id
  region = var.region
  tags = concat(var.tags, ["region:${var.region}", "project:${var.name}")
}

module "flowlogs" {
  source = "./flowlogs"
  name = var.name
  resource_group = data.ibm_resource_group.project.id
  vpc_id = module.vpc.vpc_id
  tags = concat(var.tags, ["region:${var.region}", "project:${var.name}")
  backend_subnet_id = module.vpc.backend_subnet_id
  frontend_subnet_id = module.vpc.frontend_subnet_id
}