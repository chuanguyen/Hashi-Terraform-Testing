# Defines labels to merge and apply onto K8s nodes
locals {
  # General labels for all nodes
  cluster_all_node_labels = {
    for node_name in local.cluster_all_node_names : node_name => {
      "owner"                           = "chuanguyen"
      "environment"                     = "dev"
      "topology.kubernetes.io/hostname" = (node_name)
    }
  }

  cluster_master_node_labels = {
    for node_name in local.cluster_master_node_names : node_name => {
      "svccontroller.k3s.cattle.io/enablelb" : "true"
    }
  }
}

resource "kubernetes_labels" "cluster_nodes" {
  for_each = toset(local.cluster_all_node_names)

  api_version   = "v1"
  field_manager = "tf_kubernetes_labels_cluster_nodes"
  kind          = "Node"
  metadata {
    name = each.key
  }

  # Consolidates all defined labels to apply to nodes
  labels = merge(
    local.cluster_all_node_labels[each.key],
    # Lookup used to prevent errors when node name isn't present
    lookup(local.cluster_master_node_labels, each.key, {})
  )
}

resource "kubernetes_node_taint" "mark_master_nodes" {
  for_each = toset(local.cluster_master_node_names)

  field_manager = "tf_kubernetes_node_taint_mark_master_nodes"
  metadata {
    name = each.key
  }
  taint {
    key    = "compute"
    value  = "gpu"
    effect = "NoExecute"
  }
}

# resource "kubernetes_labels" "test_node_selector" {
#   api_version = "v1"
#   kind        = "Node"
#   metadata {
#     name = "k3s-worker-0"
#   }
#   labels = merge(
#     {
#       node-select-test : "true"
#       node-select-preferred : "yes"
#     }, kubernetes_labels.cluster_nodes["k3s-worker-0"].labels
#   )
# }

# resource "kubernetes_labels" "test_node_selector_with_affinity" {
#   api_version = "v1"
#   kind        = "Node"
#   metadata {
#     name = "k3s-worker-1"
#   }
#   labels = merge(
#     {
#       node-select-test : "true"
#       node-select-preferred-2 : "yes"
#     }, kubernetes_labels.cluster_nodes["k3s-worker-1"].labels
#   )
# }