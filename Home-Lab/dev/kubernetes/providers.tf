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

    helm = {
      source  = "hashicorp/helm"
      version = "2.16.1"
    }
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "~/.kube/config"
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = "~/.kube/config"
  }
}