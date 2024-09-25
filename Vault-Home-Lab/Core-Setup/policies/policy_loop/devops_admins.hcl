# Gives ability to view top-level paths
path "kv-v2/metadata/" {
  capabilities = ["list"]
}

path "kv-v2/metadata/aws" {
  capabilities = ["list"]
}

path "kv-v2/metadata/aws/*" {
  capabilities = ["list"]
}

path "kv-v2/data/aws/*" {
  capabilities = ["create", "update", "read"]
}