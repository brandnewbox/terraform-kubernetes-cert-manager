resource "kubernetes_cluster_role" "cluster_role" {
  metadata {
    name = "${var.name}:subjectaccessreviews"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  rule {
    api_groups = ["authorization.k8s.io"]
    resources = [
      "subjectaccessreviews"
    ]
    verbs = ["create"]
  }
}