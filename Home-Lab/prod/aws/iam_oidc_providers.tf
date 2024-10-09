module "iam_oidc_provider_github" {
  source = "../../modules/aws/aws_oidc_integration/"
  count  = var.create_iam_oidc_provider_github ? 1 : 0

  openid_connect_provider_role_name       = "GitHubAction-AssumeRoleWithAction_Module-Creation"
  openid_connect_provider_url             = "https://token.actions.githubusercontent.com"
  openid_connect_provider_thumbprint_list = ["d89e3bd43d5d909b47a18977aa9d5ce36cee184c"]

  trustPolicyforProviderOIDC_conditions = {
    condition1 = {
      test     = "ForAnyValue:StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:chuanguyen/AWS-Projects:ref:refs/heads/main"]
    }
    condition2 = {
      test     = "ForAnyValue:StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
  }

}

# Customize role for Github OIDC provider

data "aws_iam_policy" "AmazonS3FullAccess" {
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy" "AWSLambda_FullAccess" {
  name = "AWSLambda_FullAccess"
}

data "aws_iam_policy" "IAMFullAccess" {
  name = "IAMFullAccess"
}

resource "aws_iam_role_policy_attachment" "OIDC-Provider-AssumeRoleWithAction_AmazonS3FullAccess" {
  role       = one(module.iam_oidc_provider_github[*].iam_openid_connect_provider_role_name)
  policy_arn = data.aws_iam_policy.AmazonS3FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "OIDC-Provider-AssumeRoleWithAction_AWSLambda_FullAccess" {
  role       = one(module.iam_oidc_provider_github[*].iam_openid_connect_provider_role_name)
  policy_arn = data.aws_iam_policy.AWSLambda_FullAccess.arn
}

resource "aws_iam_role_policy_attachment" "OIDC-Provider-AssumeRoleWithAction_IAMFullAccess" {
  role       = one(module.iam_oidc_provider_github[*].iam_openid_connect_provider_role_name)
  policy_arn = data.aws_iam_policy.IAMFullAccess.arn
}