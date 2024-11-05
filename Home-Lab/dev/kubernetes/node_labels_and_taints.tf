resource "kubernetes_labels" "dev_cluster_nodes" {
  for_each = toset(local.dev_cluster_all_node_names)

  api_version = "v1"
  kind        = "Node"
  metadata {
    name = each.key
  }
  labels = {
    "owner"                           = "chuanguyen",
    "environment"                     = "dev"
    "topology.kubernetes.io/hostname" = each.key
  }
}

resource "kubernetes_node_taint" "mark_master_nodes" {
  for_each = toset(local.dev_cluster_master_node_names)

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
#     }, kubernetes_labels.dev_cluster_nodes["k3s-worker-0"].labels
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
#     }, kubernetes_labels.dev_cluster_nodes["k3s-worker-1"].labels
#   )
# }