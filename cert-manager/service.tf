resource "kubernetes_service" "service" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" : var.name
    }, local.labels)
  }
  spec {
    type = "ClusterIP"
    port {
      name        = "tcp-prometheus-servicemonitor"
      protocol    = "TCP"
      port        = 9402
      target_port = 9402
    }
    selector = {
      "app.kubernetes.io/name" : var.name
      "app.kubernetes.io/instance" : var.instance_id
      "app.kubernetes.io/component": var.component
    }
  }
}