resource "kubernetes_role" "role" {
  metadata {
    name      = "${var.name}:leaderelection"
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  # rule {
  #   # Used for leader election by the controller
  #   # TODO: refine the permission to *just* the leader election configmap
  #   api_groups = [""]
  #   resources = [
  #     "configmaps"
  #   ]
  #   verbs = ["get", "create", "update", "patch"]
  # }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = [
      "leases"
    ]
    resource_names = [
      "cert-manager-controller"
    ]
    verbs = ["get", "create", "update", "patch"]
  }
}