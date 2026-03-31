output "vm_id" {
  value       = proxmox_virtual_environment_vm.docker.vm_id
  description = "Proxmox VM ID"
}

output "vm_name" {
  value       = proxmox_virtual_environment_vm.docker.name
  description = "VM Hostname"
}

output "ipv4_address" {
  value       = try(proxmox_virtual_environment_vm.docker.ipv4_addresses[1][0], "pending")
  description = "IPv4-Adresse der VM (aus QEMU Guest Agent)"
}

output "node_name" {
  value       = proxmox_virtual_environment_vm.docker.node_name
  description = "Proxmox Node auf dem die VM laeuft"
}

output "template_id" {
  value       = local.template_id
  description = "Verwendete Template-ID"
}
