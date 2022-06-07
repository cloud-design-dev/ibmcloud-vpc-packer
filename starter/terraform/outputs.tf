# output "ibm_instance" {
#   value = ibm_is_instance.packer.primary_network_interface.0.primary_ipv4_address
# }

output "packer_manifest" {
  value = jsondecode(data.local_file.packer_manifest.content)["builds"][0]["artifact_id"]
}