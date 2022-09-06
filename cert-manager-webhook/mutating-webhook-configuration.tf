resource "kubectl_manifest" "mutating_webhook_configuration" {
  yaml_body = <<YAML
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata: 
  name: "${var.name}"
  labels:
    app.kubernetes.io/name: "${var.name}"
    ${join("\n    ",[for key, value in local.labels : "${key}: \"${value}\""])}
  annotations:
    cert-manager.io/inject-ca-from-secret: "cert-manager/cert-manager-webhook-ca"
webhooks:
- name: "webhook.cert-manager.io"
  admissionReviewVersions: ["v1"]
  rules:
  - apiGroups:   ["cert-manager.io", "acme.cert-manager.io"]
    apiVersions: ["v1"]
    operations:  ["CREATE", "UPDATE"]
    resources:   ["*/*"]
  failurePolicy: "Fail"
  sideEffects: "None"
  clientConfig:
    service:
      name: "${var.name}"
      namespace: "${var.namespace}"
      path: "/mutate"
YAML
}