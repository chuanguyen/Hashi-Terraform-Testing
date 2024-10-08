terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
  }

  ### Used Terraform with local state to create resources and then ran a migration
  ### terraform init -migrate-state Command used

  # backend "local" {
  #   path = "./terraform.tfstate"
  # }

  backend "s3" {
    bucket         = "chuanguyen-tf-state"
    key            = "aws_prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tf_state_lock"
  }
}

resource "aws_iam_openid_connect_provider" "oidc_github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["d89e3bd43d5d909b47a18977aa9d5ce36cee184c"]
}

# Create role for Github OIDC provider

data "aws_iam_policy_document" "trustPolicyforGitHubOIDC" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_github.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:chuanguyen/AWS-Projects:ref:refs/heads/main"]
    }

    condition {
      test     = "ForAnyValue:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

  }
}

resource "aws_iam_role" "GitHubAction-AssumeRoleWithAction" {
  name               = "GitHubAction-AssumeRoleWithAction"
  assume_role_policy = data.aws_iam_policy_document.trustPolicyforGitHubOIDC.json
}

# Give roles permissions to other AWS resources

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "AWSLambda_FullAccess" {
  name = "AWSLambda_FullAccess"
}

data "aws_iam_policy" "IAMFullAccess" {
  name = "IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "GitHubAction-AssumeRoleWithAction_AmazonS3FullAccess" {
  role       = aws_iam_role.GitHubAction-AssumeRoleWithAction.name
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "GitHubAction-AssumeRoleWithAction_AWSLambda_FullAccess" {
  role       = aws_iam_role.GitHubAction-AssumeRoleWithAction.name
  policy_arn = data.aws_iam_policy.AWSLambda_FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "GitHubAction-AssumeRoleWithAction_IAMFullAccess" {
  role       = aws_iam_role.GitHubAction-AssumeRoleWithAction.name
  policy_arn = data.aws_iam_policy.IAMFullAccess.arn
}
