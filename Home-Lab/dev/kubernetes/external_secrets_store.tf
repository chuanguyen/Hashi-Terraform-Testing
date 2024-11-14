resource "helm_release" "external_secrets" {
  name = "external-secrets"

  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = "0.10.3"

  atomic = true

  create_namespace = true
  namespace        = "external-secrets"

  skip_crds = false
}

### Must deploy the helm chart beforehand
### If not, the APIs for these CRDs will fail

# Stores the Vault token Kubernetes authenticates with
resource "kubernetes_manifest" "vault_backend_secrets" {
  manifest = {
    apiVersion = "v1"
    kind       = "Secret"

    metadata = {
      name      = "vault-backend-secrets"
      namespace = "default"
    }

    type = "Opaque"
    data = {
      vault_token : base64encode(var.vault_backend_token)
    }
  }

  depends_on = [helm_release.external_secrets]
}

resource "kubernetes_manifest" "ClusterSecretStore" {
  manifest = yamldecode(<<EOF
    apiVersion: external-secrets.io/v1beta1
    kind: ClusterSecretStore
    metadata:
      name: vault-backend-secret-store
    spec:
      provider:
        vault:
          server: "${var.vault_backend_server_url}:${var.vault_backend_server_port}"
          path: "kv-v2"
          version: "v2"
          auth:
            tokenSecretRef:
              name: "vault-backend-secrets"
              namespace: "default"
              key: "vault_token"
EOF
  )

  depends_on = [kubernetes_manifest.vault_backend_secrets]
}

resource "kubernetes_manifest" "ExternalSecrets" {
  manifest = yamldecode(<<EOF
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: vault-secrets
      namespace: "default"
    spec:
      refreshInterval: "15s"
      secretStoreRef:
        name: vault-backend-secret-store
        kind: ClusterSecretStore
      target:
        name: "vault-secrets"
        creationPolicy: Owner
      data:
        - secretKey: webapp-1-mongodb-username
          remoteRef:
            key: "kv-v2/webapp-1/dev/mongo"
            property: "mongodb-user"
        - secretKey: webapp-1-mongodb-password
          remoteRef:
            key: "kv-v2/webapp-1/dev/mongo"
            property: "mongodb-password"
EOF
  )

  depends_on = [kubernetes_manifest.vault_backend_secrets]
}