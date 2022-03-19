terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ca-central-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-0aee2d0182c9054ac"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
