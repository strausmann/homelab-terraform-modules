# homelab-terraform-modules

Wiederverwendbare [OpenTofu](https://opentofu.org/) / Terraform Module fuer Proxmox VE HomeLab-Infrastruktur.

## Module

### `modules/linux-vm`

Erstellt eine Linux-VM aus einem Cloud-Init-Template auf Proxmox VE.

**Features:**
- Template-Lookup ueber **Tags** (kein Hardcoden von VM-IDs)
- Cloud-Init: IP, Gateway, DNS, SSH-Keys, Benutzer
- Optionale Disk-Vergroesserung
- QEMU Guest Agent

**Template-Tags Beispiel:**
```hcl
template_tags = ["latest", "os-ubuntu", "v-2404"]
```

### `modules/docker-node`

Spezialisierung des `linux-vm` Moduls fuer Docker-Nodes.

**Zusaetzliche Features:**
- Zweite Disk fuer `/docker` (konfigurierbare Groesse, Default: 300 GB)
- Docker-spezifische Template-Tags

## Voraussetzungen

- [OpenTofu](https://opentofu.org/) >= 1.8.0 (oder Terraform >= 1.8.0)
- [bpg/proxmox Provider](https://registry.terraform.io/providers/bpg/proxmox/latest) >= 0.66.0
- Proxmox VE 8.x oder 9.x mit API-Token
- VM-Templates mit Cloud-Init (z.B. via [Packer](https://github.com/strausmann/homelab-proxmox-templates))

## Schnellstart

```bash
# Repository klonen
git clone https://github.com/strausmann/homelab-terraform-modules.git
cd homelab-terraform-modules/examples/homelab

# Variablen konfigurieren
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars editieren mit eigenen Werten

# OpenTofu verwenden
tofu init
tofu plan
tofu apply
```

## Modul-Referenz aus Git

Module koennen direkt aus diesem Repository referenziert werden:

```hcl
module "my_vm" {
  source = "git::https://github.com/strausmann/homelab-terraform-modules.git//modules/linux-vm?ref=v1.0.0"

  vm_name       = "my-server"
  proxmox_node  = "PVE1"
  template_tags = ["latest", "os-ubuntu", "v-2404"]
  ip_address    = "dhcp"
  ssh_keys      = ["ssh-ed25519 AAAA..."]
}
```

## Variablen

Alle Module verwenden generische Defaults. Konkrete Werte (IPs, Hostnamen, Tokens) gehoeren in:
- `terraform.tfvars` (gitignored)
- CI/CD-Variablen
- SOPS-verschluesselte Secrets

**Keine konkreten Infrastruktur-Werte in diesem Repository.**

## State-Verschluesselung (OpenTofu)

OpenTofu unterstuetzt native client-seitige State-Verschluesselung:

```hcl
terraform {
  encryption {
    key_provider "pbkdf2" "main" {
      passphrase = var.state_passphrase
    }
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.main
    }
    state {
      method = method.aes_gcm.default
    }
  }
}
```

## Lizenz

MIT
