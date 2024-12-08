variable "argocd" {
  type = object({
    namespace = string
    values    = string
  })
}
