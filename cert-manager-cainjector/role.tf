resource "kubernetes_role" "role" {
  metadata {
    name      = "${var.name}:leaderelection"
    namespace = var.leader_election_namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = [
      "leases"
    ]
    resource_names = [
      "cert-manager-cainjector-leader-election",
      "cert-manager-cainjector-leader-election-core"
    ]
    verbs = ["get", "update", "patch"]
  }

  rule {
    api_groups = ["coordination.k8s.io"]
    resources = [
      "leases"
    ]
    verbs = ["create"]
  }
}