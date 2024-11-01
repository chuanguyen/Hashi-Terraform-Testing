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

resource "kubernetes_labels" "test_node_selector" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "k3s-worker-0"
  }
  labels = merge(
    {
      node-select-test : "true"
      node-select-preferred : "yes"
    }, kubernetes_labels.dev_cluster_nodes["k3s-worker-0"].labels
  )
}

resource "kubernetes_labels" "test_node_selector_with_affinity" {
  api_version = "v1"
  kind        = "Node"
  metadata {
    name = "k3s-worker-1"
  }
  labels = merge(
    {
      node-select-test : "true"
      node-select-preferred-2 : "yes"
    }, kubernetes_labels.dev_cluster_nodes["k3s-worker-1"].labels
  )
}