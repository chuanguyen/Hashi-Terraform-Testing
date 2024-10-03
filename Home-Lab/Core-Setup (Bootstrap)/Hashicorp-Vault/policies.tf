#---------------------
# Create policies
#---------------------

# Create admin policy in the root namespace
resource "vault_policy" "vault_admin_policy" {
  name   = "vault_admins"
  policy = file("policies/vault-admin-policy.hcl")
}

# Loop through HCL policy files to create
resource "vault_policy" "vault_policies" {
  for_each = fileset("${path.module}/${var.policy_files_path}", "*.hcl")

  name   = trim(each.value, ".hcl")
  policy = file("${path.module}/${var.policy_files_path}/${each.value}")
}