output "iam_oidc_provider_github_role_arn" {
  value = one(module.iam_oidc_provider_github[*].iam_openid_connect_provider_role_arn)
}