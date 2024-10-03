provider "aws" {
  profile = "default"
  region  = "us-east-1"

  # Use of default tags cleans up redundant tag definitions
  default_tags {
    tags = {
      Environment = "prod"
      Owner = "chua"
    }
  }
}