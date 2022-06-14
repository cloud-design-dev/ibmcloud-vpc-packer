variable "ibmcloud_api_key" {
  description = "IBM Cloud API Key to use for project."
  type = string
  default = "" 
}

variable "name" {
  description = "Name that will be prepended to all deployed resources."
  type = string
  default = ""
}

variable "existing_ssh_key" {
  description = "(Optional) Name of an existing SSH Key that will be added to the Warpspeed server. If none provided, one will be created."
  type = string
  default = ""
}

variable "region" {
  description = "VPC region where resources will be deployed."
  type = string
  default = ""
}

variable "resource_group" {
  description = "Name of the Resource Group to use for deployed resources."
  type = string
  default = ""
}

variable "tags" {
  description = "Default set of tags to add to all resources."
  type = list(string)
  default = ["lab-demo-vpc"]
}

variable "enable_observability" {
  default = false
}

variable "enable_data_engine" {
  default = false
}