resource "proxmox_vm_qemu" "k3s_masters" {
  count       = var.master_num_nodes
  name        = "k3s-master-${count.index}"
  target_node = var.pm_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  clone      = var.master_template_vm_name
  full_clone = var.master_full_clone
  os_type    = "cloud-init"
  agent      = var.master_enable_qemu_agent
  memory     = var.master_mem
  cores      = var.master_cpu_cores

  # Cloud-init config
  ciuser     = var.master_ciuser
  cipassword = var.master_cipassword

  ipconfig0 = "ip=dhcp"

  disk {
    slot      = "virtio0"
    cache     = "none"
    replicate = false
    size      = var.master_disk_size
    type      = var.master_disk_type
    storage   = var.master_disk_location
  }

  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.master_disk_location
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      network,
      disk
    ]
  }
}

resource "proxmox_vm_qemu" "k3s_nodes" {
  count       = var.node_num_nodes
  name        = "k3s-nodes-${count.index}"
  target_node = var.pm_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  clone      = var.node_template_vm_name
  full_clone = var.node_full_clone
  os_type    = "cloud-init"
  agent      = var.node_enable_qemu_agent
  memory     = var.node_mem
  cores      = var.node_cpu_cores

  # Cloud-init config
  ciuser     = var.node_ciuser
  cipassword = var.node_cipassword

  ipconfig0 = "ip=dhcp"

  disk {
    slot      = "virtio0"
    cache     = "none"
    replicate = false
    size      = var.node_disk_size
    type      = var.node_disk_type
    storage   = var.node_disk_location
  }

  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.node_disk_location
  }

  lifecycle {
    ignore_changes = [
      ciuser,
      network,
      disk
    ]
  }

  depends_on = [proxmox_vm_qemu.k3s_masters]
}