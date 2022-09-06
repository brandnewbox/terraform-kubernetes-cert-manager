variable "namespace" {
  type        = string
  description = "The namespace that Cert-Manager will reside in."
  default     = "cert-manager"
}
variable "namespace_annotations" {
  type        = map(string)
  description = "Additional namespace annotations."
  default     = {}
}

variable "manager_image_tag" {
  type    = string
  default = "v1.9.1" #"v1.0.2" #"v0.13.0"
}
variable "manager_image_name" {
  type    = string
  default = "jetstack/cert-manager-controller"
}

variable "cainjector_image_tag" {
  type    = string
  default = "v1.9.1" # "v1.0.2" #"v0.13.0"
}
variable "cainjector_image_name" {
  type    = string
  default = "jetstack/cert-manager-cainjector"
}

variable "webhook_image_tag" {
  type    = string
  default = "v1.9.1" # "v1.0.2" #"v0.13.0"
}
variable "webhook_image_name" {
  type    = string
  default = "jetstack/cert-manager-webhook"
}


variable "image_repository" {
  type        = string
  description = "The image repository to use when pulling images"
  default     = null
}
variable "image_pull_policy" {
  type        = string
  description = "Determines when the image should be pulled prior to starting the container. `Always`: Always pull the image. | `IfNotPresent`: Only pull the image if it does not already exist on the node. | `Never`: Never pull the image"
  default     = "IfNotPresent"
}
variable "labels" {
  type        = map(string)
  description = "(optional) A map that consists of any additional labels that should be included with resources created by this module."
  default     = {}
}
variable "certificate_issuers" {
  type = object({
    letsencrypt = object({
      name : string,
      server : string,
      email : string,
      default_issuer : bool,
      ingress_class : string
    })
    # TODO: Add support for another one so this doesnt look so silly
  })
  description = "An object that contains the configuration for all the enabled certificate issuers."
  default = {
    letsencrypt = null
  }
}