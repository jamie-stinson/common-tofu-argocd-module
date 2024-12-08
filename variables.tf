variable "argocd" {
  type = object({
    namespace = string
    values    = string
  })
}

variable "environment" {
  type = string
}
