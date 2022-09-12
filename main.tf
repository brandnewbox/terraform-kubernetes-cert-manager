module "custom_resource_definitions" {
  source = "./custom-resource-definitions"
}

module "cert_manager_cainjector" {
  source = "./cert-manager-cainjector"

  depends_on = [module.custom_resource_definitions]

  instance_id       = local.instance_id
  namespace         = kubernetes_namespace.namespace.metadata.0.name
  image_tag         = var.cainjector_image_tag
  image_name        = var.cainjector_image_name
  image_repository  = var.image_repository
  image_pull_policy = var.image_pull_policy
  labels            = local.labels
}

module "cert_manager" {
  source = "./cert-manager"

  depends_on = [module.custom_resource_definitions]

  instance_id       = local.instance_id
  namespace         = kubernetes_namespace.namespace.metadata.0.name
  image_tag         = var.manager_image_tag
  image_name        = var.manager_image_name
  image_repository  = var.image_repository
  image_pull_policy = var.image_pull_policy
  labels            = local.labels
}

module "cert_manager_webhook" {
  source = "./cert-manager-webhook"

  depends_on = [
    module.custom_resource_definitions,
    module.cert_manager_cainjector
  ]

  instance_id       = local.instance_id
  namespace         = kubernetes_namespace.namespace.metadata.0.name
  image_tag         = var.webhook_image_tag
  image_name        = var.webhook_image_name
  image_repository  = var.image_repository
  image_pull_policy = var.image_pull_policy
  labels            = local.labels
}

module "cert_manager_issuers" {
  source = "./cert-manager-issuers"

  depends_on = [
    module.custom_resource_definitions,
    module.cert_manager_webhook
  ]

  namespace   = kubernetes_namespace.namespace.metadata.0.name
  letsencrypt = var.certificate_issuers.letsencrypt
  # Others will go here...
}