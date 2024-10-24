terraform {
  backend "s3" {
    bucket         = "chuanguyen-tf-state"
    key            = "dev_proxmox.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf_state_lock"
  }

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "=3.0.1-rc4"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.provider_proxmox_endpoint
  pm_api_token_id     = var.provider_proxmox_api_token_id
  pm_api_token_secret = var.provider_proxmox_api_token_secret

  pm_tls_insecure = var.provider_proxmox_tls_insecure

  pm_log_enable = var.provider_proxmox_logging
  pm_log_file   = var.provider_proxmox_logging_file

  # Limit to 1 due to race condition on determining VM ID
  # If not, conflicts can occur with Terraform choosing the
  # same VM ID for subsequent Proxmox VMs being created
  pm_parallel = 1
  pm_timeout  = 300
}
