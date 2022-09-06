# This will be a decision tree. I should probably chop it down before it grows too large...
output "default_issuer" {
  value = lookup(local.letsencrypt, "default_issuer", false) ? var.letsencrypt.name : ""
  # lookup(local.foocrypt, "default_issuer", false) ? var.foocrypt.name : ""
}

module "letsencrypt_issuer" {
  source = "./letsencrypt"

  count = var.letsencrypt == null ? 0 : 1

  namespace         = var.namespace
  name              = var.letsencrypt.name
  server            = var.letsencrypt.server
  email             = var.letsencrypt.email
  ingress_class     = var.letsencrypt.ingress_class
}

