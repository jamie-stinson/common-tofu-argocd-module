resource "argocd_repository" "this" {
  name       = "common-helm-library"
  type       = "helm"
  repo       = "oci://ghcr.io/jamie-stinson/common-helm-library/common-helm-library"
  enable_oci = true
}