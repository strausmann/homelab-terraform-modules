# --- HomeLab VM Deployments ---
# Erstellt VMs aus Packer-Templates via Cloud-Init
#
# Verwendung:
#   tofu init
#   tofu plan
#   tofu apply

locals {
  ssh_public_keys = [
    "ssh-ed25519 AAAA... your-ansible-key",
    "ssh-ed25519 AAAA... your-personal-key",
  ]
}

# --- Beispiel: Einfache Linux-VM ---
module "example_vm" {
  source = "../../modules/linux-vm"

  vm_name        = "example-vm"
  vm_description = "Beispiel-VM via OpenTofu"
  vm_tags        = ["opentofu", "linux", "example"]

  proxmox_node  = var.proxmox_node
  template_tags = ["latest", "os-ubuntu", "v-2404"]

  cpu_cores    = 2
  memory       = 2048
  disk_size    = 30
  storage_pool = "local-lvm"

  network_bridge = "vmbr0"
  ip_address     = "dhcp"
  dns_servers    = ["1.1.1.1", "8.8.8.8"]
  search_domain  = "home.lab"

  ci_user  = "ubuntu"
  ssh_keys = local.ssh_public_keys
}

# --- Beispiel: Docker-Node ---
module "example_docker" {
  source = "../../modules/docker-node"

  vm_name        = "docker-example"
  vm_description = "Docker-Node Beispiel via OpenTofu"
  vm_tags        = ["opentofu", "linux", "docker", "example"]

  proxmox_node  = var.proxmox_node
  template_tags = ["latest", "os-ubuntu", "v-2404", "docker"]

  cpu_cores    = 4
  memory       = 8192
  disk_size    = 50
  storage_pool = "local-lvm"

  docker_disk_size = 300

  network_bridge = "vmbr0"
  ip_address     = "dhcp"
  dns_servers    = ["1.1.1.1", "8.8.8.8"]
  search_domain  = "home.lab"

  ci_user  = "ubuntu"
  ssh_keys = local.ssh_public_keys
}

# --- Outputs ---
output "example_vm_ip" {
  value = module.example_vm.ipv4_address
}

output "example_docker_ip" {
  value = module.example_docker.ipv4_address
}
