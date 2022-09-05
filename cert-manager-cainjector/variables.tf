variable "name" {
  type    = string
  default = "cert-manager-cainjector"
}
variable "instance_id" {
  type = string
}
variable "component" {
  type    = string
  default = "cainjector"
}
variable "namespace" {
  type = string
}
variable "image_tag" {
  type = string
}
variable "image_name" {
  type = string
}
variable "image_repository" {
  type = string
}
variable "image_pull_policy" {
  type = string
}
variable "labels" {
  type = map(string)
}
variable "leader_election_namespace" {
  type = string
  default = "kube-system"
}

