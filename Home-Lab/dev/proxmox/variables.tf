# Provider configuration

variable "provider_proxmox_endpoint" {
  type = string
}

variable "provider_proxmox_api_username" {
  type    = string
  default = "root"
}

variable "provider_proxmox_api_token_id" {
  type = string
}

variable "provider_proxmox_api_token_secret" {
  type = string
}

variable "provider_proxmox_logging" {
  type    = bool
  default = false
}

variable "provider_proxmox_logging_file" {
  type    = string
  default = "terraform-plugin-proxmox.log"
}

variable "provider_proxmox_tls_insecure" {
  type    = bool
  default = false
}

# Resource configuration

variable "pm_node_name" {
  description = "name of the proxmox node to create the VMs on"
  type        = string
}

## Master nodes

variable "master_num_nodes" {
  description = "Enter the number of Master VMs you want"
  default     = 1
}

variable "master_enable_qemu_agent" {
  description = "Set to 1 to enable the QEMU Guest Agent. 0 to disable"
  default     = "0"
}

variable "master_cpu_cores" {
  description = "Enter the value for the amount of cores per socket for your masters. ie. 2"
  default     = "2"
}

variable "master_mem" {
  description = "Enter the value for the amount of RAM for your masters. ie. 4096"
  default     = "4096"
}

variable "num_master_mem" {
  description = "Enter the value for the amount of RAM for your masters. ie. 4096"
  default     = "4096"
}

variable "master_ciuser" {
  description = "Cloud-init username to override the default with"
}

variable "master_cipassword" {
  description = "Cloud-init password to override the default with"
}

variable "master_disk_size" {
  description = "Enter the size of your Master node disks ie. 80G"
  type        = string
  default     = "40G"
}

variable "master_disk_type" {
  description = "What interface type are you using? ie. scsi"
  type        = string
  default     = "disk"
}

variable "master_disk_location" {
  description = "Where do you want to store the disk on your host? ie. zfs-mirror, local, local-lvm, etc."
  type        = string
  default     = "YOUR-MASTER-DISK-LOCATION"
}

variable "master_template_vm_name" {
  description = "Name of the template VM"
  type        = string
  default     = "YOUR-PM-VM-TEMPLATE-NAME"
}

variable "master_full_clone" {
  description = "Whether a full or linked clone is made"
  type        = bool
  default     = "true"
}

## Slave nodes

variable "node_num_nodes" {
  description = "Enter the number of Node VMs you want"
  default     = 1
}

variable "node_enable_qemu_agent" {
  description = "Set to 1 to enable the QEMU Guest Agent. 0 to disable"
  default     = "0"
}

variable "node_cpu_cores" {
  description = "Enter the value for the amount of cores per socket for your nodes. ie. 2"
  default     = "2"
}

variable "node_mem" {
  description = "Enter the value for the amount of RAM for your nodes. ie. 4096"
  default     = "4096"
}

variable "node_ciuser" {
  description = "Cloud-init username to override the default with"
}

variable "node_cipassword" {
  description = "Cloud-init password to override the default with"
}

variable "node_disk_size" {
  description = "Enter the size of your Node node disks ie. 80G"
  type        = string
  default     = "40G"
}

variable "node_disk_type" {
  description = "What interface type are you using? ie. scsi"
  type        = string
  default     = "disk"
}

variable "node_disk_location" {
  description = "Where do you want to store the disk on your host? ie. zfs-mirror, local, local-lvm, etc."
  type        = string
  default     = "YOUR-NODE-DISK-LOCATION"
}

variable "node_template_vm_name" {
  description = "Name of the template VM"
  type        = string
  default     = "YOUR-PM-VM-TEMPLATE-NAME"
}

variable "node_full_clone" {
  description = "Whether a full or linked clone is made"
  type        = bool
  default     = "true"
}
