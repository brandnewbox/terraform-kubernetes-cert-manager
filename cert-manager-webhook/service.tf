resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
  }
  spec {
    type = "ClusterIP"
    port {
      name        = "https"
      port        = 443
      target_port = "https"
    }
    selector = {
      app : local.app
      "app.kubernetes.io/name" : var.name
      "app.kubernetes.io/instance" : var.instance_id
      "app.kubernetes.io/component" : var.component
    }
  }
}