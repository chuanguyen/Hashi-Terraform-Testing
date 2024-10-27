terraform {
  # Must have explicitly specify the provider version
  # for modules when using non-Hashicorp providers
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "=3.0.1-rc4"
    }
  }
}