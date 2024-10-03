terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }

### Used Terraform with local state to create resources and then ran a migration
### terraform init -migrate-state Command used

#   backend "local" {
#     path = "./terraform.tfstate"
#   }

  backend "s3" {
    bucket = "chuanguyen-tf-state"
    key    = "prod/aws_core_setup.tfstate"
    region = "us-east-1"
    dynamodb_table = "tf_state_lock_prod"
  }
}