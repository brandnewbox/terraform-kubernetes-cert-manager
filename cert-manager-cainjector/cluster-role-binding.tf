resource "kubernetes_cluster_role_binding" "cluster_role_binding" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = kubernetes_cluster_role.cluster_role.metadata.0.namespace
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.service_account.metadata.0.name
    namespace = kubernetes_service_account.service_account.metadata.0.namespace
  }
}