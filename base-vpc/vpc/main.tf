resource "ibm_is_vpc" "vpc" {
  name  = "${var.name}-vpc"
  resource_group = var.resource_group
  tags  = var.tags
}

resource "ibm_is_public_gateway" "frontend" {
  name           = "${var.name}-frontend-pubgw"
  vpc            = ibm_is_vpc.vpc.id
  zone           = data.ibm_is_zones.mzr.zones[0]
  resource_group = var.resource_group
  tags           = var.tags
}

resource "ibm_is_subnet" "frontend_subnet" {
  name                     = "${var.name}-frontend-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.zone
  total_ipv4_address_count = "128"
  resource_group           = var.resource_group
  public_gateway           = ibm_is_public_gateway.frontend.id
  tags                     = var.tags
}

resource "ibm_is_subnet" "backend_subnet" {
  name                     = "${var.name}-backend-subnet"
  vpc                      = ibm_is_vpc.vpc.id
  zone                     = var.zone
  total_ipv4_address_count = "256"
  resource_group           = var.resource_group
  public_gateway           = ibm_is_public_gateway.frontend.id
  tags                     = var.tags
}

