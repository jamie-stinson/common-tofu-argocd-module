resource "argocd_project" "this" {
  metadata {
    name      = "${var.environment}"
    namespace = "${var.argocd.namespace}
  }
  spec {
    source_namespaces = ["*"]
    source_repos      = ["*"]

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "*"
    }
  }
}
