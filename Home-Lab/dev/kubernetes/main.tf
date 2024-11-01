data "kubernetes_nodes" "dev_cluster_nodes" {}

locals {
  dev_cluster_node_names = [for node in data.kubernetes_nodes.dev_cluster_nodes.nodes : node.metadata.0.name]
}

resource "kubernetes_labels" "dev_cluster_nodes" {
  for_each = toset(local.dev_cluster_node_names)

  api_version = "v1"
  kind        = "Node"
  metadata {
    name = each.key
  }
  labels = {
    "owner"       = "chuanguyen",
    "environment" = "dev"
  }
}