resource "proxmox_vm_qemu" "pm_vm_node" {
  name        = var.pm_vm_name
  target_node = var.pm_target_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  clone      = var.pm_vm_template_name
  full_clone = var.pm_vm_full_clone
  os_type    = var.pm_vm_os_type
  agent      = var.pm_vm_enable_qemu_agent
  memory     = var.pm_vm_mem
  cores      = var.pm_vm_cpu_cores

  # Cloud-init config
  ciuser     = var.pm_vm_ciuser
  cipassword = var.pm_vm_cipassword

  ipconfig0 = var.pm_vm_net_ipconfig0


  dynamic "disk" {
    for_each = var.pm_vm_disks

    content = {
        disk.key = disk.value
    }
  }

  disk {
    ### Comment if the slot is necessary for the cloudinit drive
    # slot    = "ide0"
    type    = "cloudinit"
    storage = var.pm_vm_disk_location
  }

  lifecycle {
    ignore_changes = var.pm_vm_lifecycle_ignored_change
  }
}

# Iterates through created Proxmox VMs
# Maps node IP to the node name
locals {
  node_ip = {
      pm_vm_name = pm_vm_node.name
      pm_vm_ip   = pm_vm_node.default_ipv4_address
    }
}