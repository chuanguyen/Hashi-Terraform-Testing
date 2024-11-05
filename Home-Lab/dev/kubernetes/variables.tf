variable "vault_backend_server_url" {
  type = string
}

variable "vault_backend_server_port" {
  type    = string
  default = "8200"
}

variable "vault_backend_token" {
  type = string
}