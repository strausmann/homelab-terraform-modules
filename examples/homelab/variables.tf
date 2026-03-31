# --- Proxmox Verbindung ---

variable "proxmox_url" {
  type        = string
  description = "Proxmox API URL (z.B. https://pve.example.com:8006/)"
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "Proxmox API Token im Format 'user@realm!token-name=token-secret'"
}

variable "proxmox_skip_tls" {
  type        = bool
  default     = true
  description = "TLS-Zertifikatspruefung ueberspringen (fuer self-signed Certs)"
}

variable "proxmox_node" {
  type        = string
  default     = "pve"
  description = "Proxmox Node-Name"
}
