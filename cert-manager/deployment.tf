resource "kubernetes_deployment" "deployment" {
  metadata {
    labels = merge({
      "app.kubernetes.io/name" = var.name
    }, local.labels)
    annotations = {}
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        "app.kubernetes.io/name"       = var.name
        "app.kubernetes.io/instance"   = var.instance_id
        "app.kubernetes.io/component"  = var.component
      }
    }
    template {
      metadata {
        labels = merge({
          "app.kubernetes.io/name" = var.name
        }, local.labels)
        annotations = {
          "prometheus.io/path"   = "/metrics"
          "prometheus.io/scrape" = "true"
          "prometheus.io/port"   = "9402"
        }
      }
      spec {
        service_account_name            = kubernetes_service_account_v1.service_account.metadata.0.name

        security_context {
          run_as_non_root = true
        }

        node_selector = {
          "kubernetes.io/os" = "linux"
        }

        container {
          name              = var.name
          image             = "${local.image_repository}/${var.image_name}:${var.image_tag}"
          image_pull_policy = var.image_pull_policy
          args = [
            "--v=2",
            "--cluster-resource-namespace=$(POD_NAMESPACE)",
            "--leader-election-namespace=${var.leader_election_namespace}"
          ]
          port {
            protocol       = "TCP"
            container_port = 9402
            name           = "http-metrics"
          }
          env {
            name  = "POD_NAMESPACE"

            value_from {
              field_ref {
                api_version = "v1"
                field_path = "metadata.namespace"
              }
            }
          }

          security_context {
            allow_privilege_escalation = false
          }

          resources {
            requests = {
              cpu    = "10m"
              memory = "32Mi"
            }
          }
        }
      }
    }
  }
}

data "kubernetes_service_account_v1" "service_account" {
  metadata {
    name = kubernetes_service_account_v1.service_account.metadata.0.name
    namespace = kubernetes_service_account_v1.service_account.metadata.0.namespace
  }
}