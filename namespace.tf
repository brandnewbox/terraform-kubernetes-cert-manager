resource "kubernetes_namespace" "namespace" {
  metadata {
    name        = var.namespace
    labels      = local.labels
    annotations = var.namespace_annotations
  }
  lifecycle {
    ignore_changes = [
      metadata[0].annotations["cattle.io/status"],
      metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"],
      metadata[0].annotations["management.cattle.io/no-default-sa-token"],
      metadata[0].labels["field.cattle.io/projectId"]
    ]
  }
}