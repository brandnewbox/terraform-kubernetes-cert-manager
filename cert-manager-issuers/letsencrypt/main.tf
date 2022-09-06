terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
  }
}

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
      name: ${var.name}
    solvers:
    - http01: 
        ingress: 
          class: ${var.ingress_class}
YAML
}