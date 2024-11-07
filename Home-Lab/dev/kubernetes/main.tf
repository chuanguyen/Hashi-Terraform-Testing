data "kubernetes_nodes" "cluster_nodes" {}

data "kubernetes_nodes" "cluster_master_nodes" {
  metadata {
    labels = {
      "node-role.kubernetes.io/master" = "true"
    }
  }
}

locals {
  cluster_all_node_names    = [for node in data.kubernetes_nodes.cluster_nodes.nodes : node.metadata.0.name]
  cluster_master_node_names = [for node in data.kubernetes_nodes.cluster_master_nodes.nodes : node.metadata.0.name]
  cluster_worker_node_names = setsubtract(local.cluster_all_node_names, local.cluster_master_node_names)
}