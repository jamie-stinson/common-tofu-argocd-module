resource "helm_release" "argocd" {
  name             = "argocd"
  namespace = "${var.argocd.namespace}"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.7"

  set_sensitive {
    name = "configs.secret.argocdServerAdminPassword"
    value = bcrypt(random_password.argocd_admin_password.result)
  }

  values = [
    yamlencode({
      redis-ha = {
        enabled = "true"
      }
    })
  ]
  timeout          = 600
  create_namespace = true
  wait             = true
}
