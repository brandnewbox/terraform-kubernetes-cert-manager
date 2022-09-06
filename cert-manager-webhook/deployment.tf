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
        name      = var.name
        namespace = var.namespace
        labels = merge({
          "app.kubernetes.io/name" = var.name
        }, local.labels)
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
            "--secure-port=10250",
            "--dynamic-serving-ca-secret-namespace=$(POD_NAMESPACE)",
            "--dynamic-serving-ca-secret-name=cert-manager-webhook-ca",
            "--dynamic-serving-dns-names=cert-manager-webhook,cert-manager-webhook.cert-manager,cert-manager-webhook.cert-manager.svc"
          ]
          liveness_probe {
            http_get {
              path   = "/livez"
              port   = 6080
              scheme = "HTTP"
            }
          }
          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "6080"
              scheme = "HTTP"
            }
          }
          port {
            protocol       = "TCP"
            container_port = 10250
            name           = "https"
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
              cpu    = "100m"
              memory = "300Mi"
            }
            limits = {
              cpu    = "100m"
              memory = "300Mi"
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