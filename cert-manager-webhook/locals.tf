locals {
  image_repository = var.image_repository == null ? "quay.io" : var.image_repository
  app = "webhook"
  labels = merge({
    "app.kubernetes.io/component" = var.component
    # Some more labels go here...
  }, var.labels)
}