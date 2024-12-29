resource "kubectl_manifest" "project" {
    yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: "${var.environment}"
  namespace: "${var.argocd.namespace}"
spec:
  sourceNamespaces:
    - "*"
  sourceRepos:
    - "*"
  clusterResourceWhitelist:
    - group: '*'
      kind: '*'
  destinations:
    - server: https://kubernetes.default.svc
      namespace: "*"
YAML
  depends_on  = [
    helm_release.this
  ]
}
