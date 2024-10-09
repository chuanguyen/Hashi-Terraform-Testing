output "iam_openid_connect_provider_arn" {
    value = aws_iam_openid_connect_provider.oidc_provider.arn
}

output "iam_openid_connect_provider_role_arn" {
    value = aws_iam_role.OIDC-Provider-AssumeRoleWithAction.arn
}

output "iam_openid_connect_provider_role_name" {
    value = aws_iam_role.OIDC-Provider-AssumeRoleWithAction.name
}