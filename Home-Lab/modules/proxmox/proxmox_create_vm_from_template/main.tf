resource "proxmox_vm_qemu" "pm_vm_node" {
  count = var.pm_vm_count

  name        = "${var.pm_vm_name}-${count.index}"
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

    content {
        slot = disk.value.slot
        cache = disk.value.cache
        replicate = disk.value.replicate
        size = disk.value.size
        type = disk.value.type
        storage = disk.value.storage
    }
  }

  disk {
    ### Comment if the slot is necessary for the cloudinit drive
    slot    = var.pm_vm_cloudinit_disk_slot
    type    = "cloudinit"
    storage = var.pm_vm_cloudinit_disk_location
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      network,
      disk
    ]
  }
}

# Iterates through created Proxmox VMs
# Builds a map of the VM's name and corresponding discovered IPv4 address
locals {
  pm_vm_outputs = {
    for pm_vm_node in proxmox_vm_qemu.pm_vm_node : pm_vm_node.name => pm_vm_node.default_ipv4_address
  }
}