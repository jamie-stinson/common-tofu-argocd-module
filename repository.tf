resource "argocd_repository" "this" {
  repo = "oci://ghcr.io/jamie-stinson/common-helm-library/common-helm-library"
  name = "common-helm-library"
  type = "helm"
  enable_oci = true
}
