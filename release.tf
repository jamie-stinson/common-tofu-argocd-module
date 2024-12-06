resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  chart            = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  version          = "7.7.7"
  values = [
    var.argocd.values,
    yamlencode({
      configs = {
        secret = {
          argocdServerAdminPassword = bcrypt(random_password.argocd_admin_password.result)
        }
      }
    })
  ]  create_namespace = true
  timeout          = 600
  wait             = true
}
