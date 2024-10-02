terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  backend "local" {
    path = "./terraform.tfstate"
  }
}

resource "aws_iam_openid_connect_provider" "oidc_github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["D89E3BD43D5D909B47A18977AA9D5CE36CEE184C"]
}

# Create role for Github OIDC provider

data "aws_iam_policy_document" "trustPolicyforGitHubOIDC" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_github.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
        test = "ForAnyValue:StringEquals"
        variable = "token.actions.githubusercontent.com:sub"
        values = ["repo:chuanguyen/AWS-Projects:ref:refs/heads/main"]
    }

    condition {
        test = "ForAnyValue:StringEquals"
        variable = "token.actions.githubusercontent.com:aud"
        values = ["sts.amazonaws.com"]
    }

  }
}

# Assume Role Policy is separate from the other policies I created
resource "aws_iam_role" "GitHubAction-AssumeRoleWithAction" {
  name               = "GitHubAction-AssumeRoleWithAction"
  assume_role_policy = data.aws_iam_policy_document.trustPolicyforGitHubOIDC.json
}
