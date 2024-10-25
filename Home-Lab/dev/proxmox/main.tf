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

resource "proxmox_vm_qemu" "k3s_workers" {
  count       = var.worker_num_nodes
  name        = "k3s-worker-${count.index}"
  target_node = var.pm_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  clone      = var.worker_template_vm_name
  full_clone = var.worker_full_clone
  os_type    = "cloud-init"
  agent      = var.worker_enable_qemu_agent
  memory     = var.worker_mem
  cores      = var.worker_cpu_cores

  # Cloud-init config
  ciuser     = var.worker_ciuser
  cipassword = var.worker_cipassword

  ipconfig0 = "ip=dhcp"

  disk {
    slot      = "virtio0"
    cache     = "none"
    replicate = false
    size      = var.worker_disk_size
    type      = var.worker_disk_type
    storage   = var.worker_disk_location
  }

  disk {
    slot    = "ide0"
    type    = "cloudinit"
    storage = var.worker_disk_location
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

# Iterates through created Proxmox VMs
# Maps node IP to the node name
locals {
  master_node_ips = [for master_node in proxmox_vm_qemu.k3s_masters :
    {
      master_name = master_node.name
      master_ip   = master_node.default_ipv4_address
    }
  ]
  worker_node_ips = [for worker_node in proxmox_vm_qemu.k3s_workers :
    {
      worker_name = worker_node.name
      worker_ip   = worker_node.default_ipv4_address
    }
  ]
}