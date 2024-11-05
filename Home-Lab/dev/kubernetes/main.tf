data "kubernetes_nodes" "dev_cluster_nodes" {}

data "kubernetes_nodes" "dev_cluster_master_nodes" {
  metadata {
    labels = {
      "node-role.kubernetes.io/master" = "true"
    }
  }
}

locals {
  dev_cluster_all_node_names    = [for node in data.kubernetes_nodes.dev_cluster_nodes.nodes : node.metadata.0.name]
  dev_cluster_master_node_names = [for node in data.kubernetes_nodes.dev_cluster_master_nodes.nodes : node.metadata.0.name]
  dev_cluster_worker_node_names = setsubtract(local.dev_cluster_all_node_names, local.dev_cluster_master_node_names)
}