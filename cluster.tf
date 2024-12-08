resource "argocd_cluster" "this" {
  server = "https://kubernetes.default.svc"
  config = {
    name = "${var.environment}"
  }
}
