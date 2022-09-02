variable "name" {
  type = string
}
variable "namespace" {
  type = string
}
variable "server" {
  type = string
}
variable "email" {
  type = string
}
variable "ingress_class" {
  type = string
}
variable "secret_base64_key" {
  type = string
}

resource "kubernetes_secret" "letsencrypt_issuer_secret" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }
  data = {
    # We decode it before injecting it because the provider will re-encode it.
    "tls.key" = base64decode(var.secret_base64_key)
  }
}

resource "kubectl_manifest" "letsencrypt_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata: 
  name: ${var.name}
  labels:
    name: ${var.name}
spec: 
  acme: 
    server: ${var.server}
    email: ${var.email}
    privateKeySecretRef: 
      name: ${kubernetes_secret.letsencrypt_issuer_secret.metadata.0.name}
    solvers:
    - http01: 
        ingress: 
          class: ${var.ingress_class}
YAML
}