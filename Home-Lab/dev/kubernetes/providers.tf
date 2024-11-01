terraform {
  backend "s3" {
    bucket         = "chuanguyen-tf-state"
    key            = "dev_kubernetes.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf_state_lock"
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.33.0"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "~/.kube/config"
}