resource "kubernetes_deployment" "deployment" {
  metadata {
    name      = var.name
    namespace = var.namespace
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
    annotations = {}
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app                            = local.app
        "app.kubernetes.io/name"       = var.name
        "app.kubernetes.io/instance"   = var.instance_id
        "app.kubernetes.io/managed-by" = "terraform"
      }
    }
    template {
      metadata {
        name      = var.name
        namespace = var.namespace
        labels = merge({
          "app.kubernetes.io/name" = var.name
        }, local.labels)
      }
      spec {
        service_account_name            = kubernetes_service_account_v1.service_account.metadata.0.name
        automount_service_account_token = false
        container {
          name              = var.name
          image             = "${local.image_repository}/${var.image_name}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy
          args = [
            "--v=2",
            "--leader-election-namespace=kube-system"
          ]
          env {
            name  = "POD_NAMESPACE"
            value = var.namespace
          }
          # TODO: Resources for cainjector
          resources {}
          volume_mount {
            name       = "service-token"
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount/"
            read_only  = true
          }
        }
        volume {
          name = "service-token"
          secret {
            secret_name = kubernetes_service_account_v1.service_account.default_secret_name
          }
        }
      }
    }
  }
}