# --- Smoke-Test: LUKS-Template (Issue #213 Phase 4) ---
# Klont das neue LUKS-Template um zu verifizieren dass:
#   1. LUKS2-Unlock beim Boot funktioniert (manuell mit "packer-build-only")
#   2. cloud-init nach Unlock durchlaeuft
#   3. SSH erreichbar ist
#   4. Disk-Layout stimmt (direct-layout, KEIN LVM)
#
# HINWEIS: Nach Boot muss an der Proxmox-Konsole manuell die LUKS-Passphrase
# eingegeben werden (packer-build-only). Erst danach laeuft cloud-init und
# die VM wird erreichbar — tofu apply bleibt bis dahin im Wartezustand.
#
# Naechster Schritt nach erfolgreichem Smoke-Test: Ansible-Playbook
# encrypt-vm-tang.yml ausfuehren fuer Tang-Binding (Issue #213).

module "luks_smoketest_01" {
  source = "../../modules/linux-vm"

  vm_name        = "luks-smoketest-01"
  vm_description = "LUKS-Template Smoke-Test (Issue #213 Phase 4) — kann nach Test geloescht werden"
  vm_tags        = ["opentofu", "linux", "test", "luks", "smoketest"]
  vm_id          = 146

  proxmox_node = "PVE1"
  template_id  = 9051 # tmpl-ubuntu-luks-2404-20260415-b92 (aus Pipeline 25728)

  cpu_cores    = 2
  memory       = 2048
  storage_pool = "nvme"

  network_bridge = "vnet60"
  ip_address     = "dhcp"
  dns_servers    = ["172.16.60.1", "1.1.1.1"]
  search_domain  = "strausmann.de"

  ci_user = "ubuntu"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6gqu8YPR+KppBxvK+rsQHKeWq5jY/zC5HJO3sPmx1K ansible-vm-homelab-nodes",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARsgv7N7lCpWsn2jy8w8Se2sqKulcaAM8ACIda4B7gm strausmann",
  ]
}

output "luks_smoketest_01_ip" {
  value       = module.luks_smoketest_01.ipv4_address
  description = "DHCP-IP der Smoke-Test VM (erscheint erst nach LUKS-Unlock + cloud-init)"
}

# --- Smoke-Test 02: End-to-End Test mit Template 9052 (Keyfile in initramfs) ---
# Template 9052 hat KEYFILE_PATTERN in initramfs → VM bootet OHNE Konsoleneingabe.
# Ansible-Role cleanup_keyfile entfernt das Keyfile nach Tang-Bind komplett.
# End-to-End-Test: Boot ohne Keyfile (nur Tang) nach Ansible-Role.

module "luks_smoketest_02" {
  source = "../../modules/linux-vm"

  vm_name        = "luks-smoketest-02"
  vm_description = "LUKS-Template Smoke-Test 02 — Template 9052 mit Keyfile in initramfs (autoboot ohne Konsoleneingabe)"
  vm_tags        = ["opentofu", "linux", "test", "luks", "smoketest"]
  vm_id          = 147

  proxmox_node = "PVE1"
  template_id  = 9052 # tmpl-ubuntu-luks-2404-20260415-b98 (KEYFILE_PATTERN in initramfs, Pipeline 25736)

  cpu_cores    = 2
  memory       = 2048
  storage_pool = "nvme"

  network_bridge = "vnet60"
  ip_address     = "dhcp"
  dns_servers    = ["172.16.60.1", "1.1.1.1"]
  search_domain  = "strausmann.de"

  ci_user = "ubuntu"
  ssh_keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK6gqu8YPR+KppBxvK+rsQHKeWq5jY/zC5HJO3sPmx1K ansible-vm-homelab-nodes",
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARsgv7N7lCpWsn2jy8w8Se2sqKulcaAM8ACIda4B7gm strausmann",
  ]
}

output "luks_smoketest_02_ip" {
  value       = module.luks_smoketest_02.ipv4_address
  description = "DHCP-IP der zweiten Smoke-Test VM"
}
