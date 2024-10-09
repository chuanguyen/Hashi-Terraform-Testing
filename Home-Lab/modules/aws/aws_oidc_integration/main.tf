resource "aws_iam_openid_connect_provider" "oidc_provider" {
  url = var.openid_connect_provider_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = var.openid_connect_provider_thumbprint_list
}

data "aws_iam_policy_document" "trustPolicyforProviderOIDC" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    dynamic "condition" {
        for_each = var.trustPolicyforProviderOIDC_conditions

        content {
            test = condition.value["test"]
            variable = condition.value["variable"]
            values = condition.value["values"]
        }
    }
  }
}

resource "aws_iam_role" "OIDC-Provider-AssumeRoleWithAction" {
  name               = var.openid_connect_provider_role_name
  assume_role_policy = data.aws_iam_policy_document.trustPolicyforProviderOIDC.json
}