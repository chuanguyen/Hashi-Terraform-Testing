variable "pm_target_node_name" {
  description = "name of the proxmox host to create the VMs on"
  type        = string
}

# Node configuration

variable "pm_vm_name" {
  description = "Set name of the node being created"
}

variable "pm_vm_os_type" {
  description = "Set OS type of VM being created ie. cloud-init, ubuntu, centos"
  default = "cloud-init"
}

variable "pm_vm_enable_qemu_agent" {
  description = "Set to 1 to enable the QEMU Guest Agent. 0 to disable"
  default     = "0"
}

variable "pm_vm_cpu_cores" {
  description = "Enter the value for the amount of cores per socket ie. 2"
  default     = "2"
}

variable "pm_vm_mem" {
  description = "Enter the value for the amount of RAM ie. 4096"
  default     = "4096"
}

variable "pm_vm_ciuser" {
  description = "Cloud-init username to override the default with"
}

variable "pm_vm_cipassword" {
  description = "Cloud-init password to override the default with"
}

variable "pm_vm_disks" {
    type = list(object({
      slot = string
      cache = string
      replicate = bool
      size = string
      type = string
      storage = string
    }))

    description = "A list of disk object maps for creating on the node"
    default = [
      {
        slot = "virtio0"
        cache = "none"
        replicate = false
        size = "20G"
        type = "disk"
        storage = "local-lvm"
      }
    ]
}

variable "pm_vm_cloudinit_disk_slot" {
  description = "Which slot to connect the cloudinit drive to"
  type        = string
  default     = "ide0"
}

variable "pm_vm_cloudinit_disk_location" {
  description = "Where do you want to store the cloudinit disk on your host? ie. zfs-mirror, local, local-lvm, etc."
  type        = string
  default     = "local-lvm"
}

variable "pm_vm_net_ipconfig0" {
  description = "Define the IP configuration on the 1st interface"
  type        = string
  default     = "ip=dhcp"
}

variable "pm_vm_template_name" {
  description = "Name of the template as base for node being created"
  type        = string
  default     = "YOUR-PM-VM-TEMPLATE-NAME"
}

variable "pm_vm_full_clone" {
  description = "Whether a full or linked clone is made"
  type        = bool
  default     = "true"
}