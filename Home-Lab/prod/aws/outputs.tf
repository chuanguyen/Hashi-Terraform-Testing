output "github_oidc_role_arn" {
    value = aws_iam_role.GitHubAction-AssumeRoleWithAction.arn
}