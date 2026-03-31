# --- Template-Auswahl ---

variable "template_tags" {
  type        = list(string)
  default     = ["latest", "os-ubuntu", "v-2404"]
  description = "Tags zum automatischen Finden des VM-Templates"
}

variable "template_id" {
  type        = number
  default     = null
  description = "Explizite VM-Template-ID (ueberschreibt Tag-basierte Suche)"
}

# --- VM-Identitaet ---

variable "vm_name" {
  type        = string
  description = "VM Hostname"
}

variable "vm_description" {
  type        = string
  default     = "Managed by OpenTofu"
}

variable "vm_tags" {
  type        = list(string)
  default     = ["opentofu", "linux"]
}

variable "vm_id" {
  type        = number
  default     = null
  description = "VM ID (null = automatisch)"
}

# --- Proxmox ---

variable "proxmox_node" {
  type        = string
  description = "Proxmox Node-Name (z.B. PVE1)"
}

# --- Hardware ---

variable "cpu_cores" {
  type        = number
  default     = 2
  description = "Anzahl CPU-Kerne"
}

variable "memory" {
  type        = number
  default     = 2048
  description = "RAM in MB"
}

variable "disk_size" {
  type        = number
  default     = null
  description = "Disk-Groesse in GB (null = Template-Groesse beibehalten)"
}

variable "storage_pool" {
  type        = string
  default     = "local-lvm"
  description = "Proxmox Storage Pool fuer die Disk"
}

# --- Netzwerk ---

variable "network_bridge" {
  type        = string
  default     = "vmbr0"
  description = "Proxmox Netzwerk-Bridge"
}

variable "ip_address" {
  type        = string
  description = "IP-Adresse mit CIDR (z.B. 10.0.1.10/24) oder 'dhcp'"
}

variable "gateway" {
  type        = string
  default     = null
  description = "Standard-Gateway"
}

variable "dns_servers" {
  type        = list(string)
  default     = ["1.1.1.1", "8.8.8.8"]
  description = "DNS-Server fuer die VM"
}

variable "search_domain" {
  type        = string
  default     = "home.lab"
  description = "DNS Search Domain"
}

# --- Cloud-Init ---

variable "ci_user" {
  type        = string
  default     = "ubuntu"
  description = "Cloud-Init Benutzername"
}

variable "ci_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Cloud-Init Passwort (optional, sensitiv)"
}

variable "ssh_keys" {
  type        = list(string)
  description = "SSH Public Keys fuer Cloud-Init"
  default = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6gqu8YPR+KppBxvK+rsQHKeWq5jY/zC5HJO3sPmx1K ansible-vm-homelab-nodes",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARsgv7N7lCpWsn2jy8w8Se2sqKulcaAM8ACIda4B7gm strausmann",
  ]
}
