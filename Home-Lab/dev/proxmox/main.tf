module "k3s_masters" {
  source = "../../modules/proxmox/proxmox_create_vm_from_template"

  pm_vm_count         = var.master_num_nodes
  pm_vm_name          = "k3s-master"
  pm_target_node_name = var.pm_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  pm_vm_template_name     = var.master_template_vm_name
  pm_vm_full_clone        = var.master_full_clone
  pm_vm_enable_qemu_agent = var.master_enable_qemu_agent
  pm_vm_mem               = var.master_mem
  pm_vm_cpu_cores         = var.master_cpu_cores

  # Cloud-init config
  pm_vm_ciuser     = var.master_ciuser
  pm_vm_cipassword = var.master_cipassword

  pm_vm_disks = [
    {
      slot      = "virtio0"
      cache     = "none"
      replicate = false
      size      = var.master_disk_size
      type      = var.master_disk_type
      storage   = var.master_disk_location
    }
  ]
}

module "k3s_workers" {
  source = "../../modules/proxmox/proxmox_create_vm_from_template"

  pm_vm_count         = var.worker_num_nodes
  pm_vm_name          = "k3s-worker"
  pm_target_node_name = var.pm_node_name
  # When cloning, ensure the disk size matches the disk in the template
  # Otherwise, disk won't clone properly
  pm_vm_template_name     = var.worker_template_vm_name
  pm_vm_full_clone        = var.worker_full_clone
  pm_vm_enable_qemu_agent = var.worker_enable_qemu_agent
  pm_vm_mem               = var.worker_mem
  pm_vm_cpu_cores         = var.worker_cpu_cores

  # Cloud-init config
  pm_vm_ciuser     = var.worker_ciuser
  pm_vm_cipassword = var.worker_cipassword

  pm_vm_disks = [
    {
      slot      = "virtio0"
      cache     = "none"
      replicate = false
      size      = var.worker_disk_size
      type      = var.worker_disk_type
      storage   = var.worker_disk_location
    }
  ]

  depends_on = [module.k3s_masters]
}

# Create variables for the node to IP mapping
locals {
  master_node_ips = module.k3s_masters.pm_vm_outputs
  worker_node_ips = module.k3s_workers.pm_vm_outputs
}