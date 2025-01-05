resource "helm_release" "this" {
  name             = "argocd"
  namespace        = "${var.argocd.namespace}"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.7"
  timeout          = 1200
  create_namespace = true
  values           = [<<EOF
configs:
  params:
    server.insecure: "true"
EOF
  ]
}
