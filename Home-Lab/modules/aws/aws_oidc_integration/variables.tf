variable "openid_connect_provider_url" {
  type = string
}

variable "openid_connect_provider_thumbprint_list" {
  type = list(string)
}

variable "openid_connect_provider_role_name" {
  type = string
  description = "Name for role to associate with OIDC integration"
}

variable "trustPolicyforProviderOIDC_conditions" {
  type = map(object({
        test = string
        variable = string
        values = list(string)
    }))
}