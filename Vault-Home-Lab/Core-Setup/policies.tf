#---------------------
# Create policies
#---------------------

# Create admin policy in the root namespace
resource "vault_policy" "vault_admin_policy" {
  name   = "vault_admins"
  policy = file("policies/vault-admin-policy.hcl")
}
