variable "pm_target_node_name" {
  description = "name of the proxmox host to create the VMs on"
  type        = string
}

# Node configuration

variable "pm_vm_name" {
  description = "Set name of the node being created"
  default     = "0"
}

variable "pm_vm_os_type" {
  description = "Set OS type of VM being created ie. cloud-init, ubuntu, centos"
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

variable "num_pm_vm_mem" {
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
    type = list()
    description = "A list of disk object maps for creating on the node"
    default = [
        {
            slot = "virtio0"
            cache = "none"
            replicate = false
            size = "20G"
            type = disk
            storage = "local-lvm"
        }
    ]

}

# variable "pm_vm_disk_size" {
#   description = "Enter the size of your node disks ie. 80G"
#   type        = string
#   default     = "40G"
# }

# variable "pm_vm_disk_type" {
#   description = "What interface type are you using? ie. scsi"
#   type        = string
#   default     = "disk"
# }

# variable "pm_vm_disk_location" {
#   description = "Where do you want to store the disk on your host? ie. zfs-mirror, local, local-lvm, etc."
#   type        = string
#   default     = "YOUR-DISK-LOCATION"
# }

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

variable "pm_vm_lifecycle_ignored_changes" {
  description = "Whether a full or linked clone is made"
  type        = list()
  default     = [
    ciuser,
    network,
    disk
  ]
}