resource "kubernetes_cluster_role_binding" "issuers_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-issuers"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.issuers_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role_binding" "clusterissuers_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-clusterissuers"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.clusterissuers_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role_binding" "certificates_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-certificates"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.certificates_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role_binding" "orders_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-orders"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.orders_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role_binding" "challenges_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-challenges"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.challenges_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}

resource "kubernetes_cluster_role_binding" "ingress-shim_cluster_role_binding" {
  metadata {
    name = "${var.name}-controller-ingress-shim"
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ingress_shim_cluster_role.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}