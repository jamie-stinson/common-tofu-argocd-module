output "argocd_admin_password" {
  value     = random_password.argocd_admin_password.result
  sensitive = true
}
