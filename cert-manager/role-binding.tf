resource "kubernetes_role_binding" "role_binding" {
  metadata {
    name      = "${var.name}:leaderelection"
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.role.metadata.0.name
  }
  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}