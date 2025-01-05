resource "kubectl_manifest" "applicationset" {
    sensitive_fields = [
        "spec.templatePatch"
    ]
    yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: system
  namespace: ${var.argocd.namespace}
spec:
  generators:
    - git:
        files:
          - path: charts/*/environments/${var.environment}/values.yaml
        repoURL: https://github.com/jamie-stinson/helm-system-monorepo.git
        revision: HEAD
  goTemplate: true
  template:
    metadata:
      name: "{{ index .path.segments 1 }}"
    spec:
      destination:
        name: "in-cluster"
        namespace: "{{ if .namespace }}{{ .namespace }}{{ else }}{{ index .path.segments 1 }}{{ end }}"
      project: "{{ index .path.segments 3 }}"
      revisionHistoryLimit: 3
      syncPolicy:
        automated:
          allowEmpty: true
          prune: true
          selfHeal: true
        retry:
          backoff:
            duration: 5s
            factor: 2
            maxDuration: 3m
          limit: 3
        syncOptions:
          - Validate=true
          - CreateNamespace=true
          - PrunePropagationPolicy=foreground
          - PruneLast=true
          - ServerSideApply=true
          - RespectIgnoreDifferences=false
          - ApplyOutOfSyncOnly=false
  templatePatch: |
    spec:
      sources:
        - repoURL: "ghcr.io/jamie-stinson/common-helm-library"
          chart: "common-helm-library"
          targetRevision: "1.*.*"
          helm:
            releaseName: "{{ index .path.segments 1 }}"
            valueFiles:
              - "$values/global-values.yaml"
              - "$values/charts/{{ index .path.segments 1 }}/values.yaml"
              - "$values/charts/{{ index .path.segments 1 }}/environments/{{ index .path.segments 3 }}/values.yaml"
            valuesObject:
              ingress:
                domain: "${var.cloudflare_domain}"
            {{- if eq (index .path.segments 1) "ingress-certificate" }}
              wildcardCertificate:
                apiToken: "${var.cloudflare_api_token}"
                domain: "${var.cloudflare_domain}"
                email: "${var.cloudflare_email}"
            {{- end }}
        - repoURL: https://github.com/jamie-stinson/helm-system-monorepo.git
          targetRevision: HEAD
          ref: values
          {{- if .installCRDs }}
          path: charts/{{ index .path.segments 1 }}/crds
          {{- end }}
YAML
  depends_on  = [
    helm_release.this,
    kubectl_manifest.project
  ]
}
