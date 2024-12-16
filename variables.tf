variable "argocd" {
  type = object({
    namespace = string
  })
}

variable "environment" {
  type = string
}
