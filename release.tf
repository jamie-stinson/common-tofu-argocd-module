resource "helm_release" "this" {
  name             = "argocd"
  namespace        = "${var.argocd.namespace}"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.7"
  timeout          = 1200
  create_namespace = true
  values           = [<<EOF
server:
  service:
    type: NodePort
    nodePortHttp: "30081"
    nodePortHttps: "30444"
EOF
  ]
}
