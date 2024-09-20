#--------------------------------
# Enable userpass auth method
#--------------------------------

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

# Create a user
resource "vault_generic_endpoint" "sysadmin" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/sysadmin"
  ignore_absent_fields = true

  data_json = jsonencode(
    {
      "policies": ["vault_admins"],
      "password": "changeme"
    }
  )
}
