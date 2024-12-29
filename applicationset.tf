resource "kubectl_manifest" "applicationset" {
    yaml_body = <<YAML
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: external
  namespace: ${var.argocd.namespace}
spec:
  generators:
    - git:
        files:
          - path: charts/*/environments/${var.environment}/values.yaml
        repoURL: https://github.com/jamie-stinson/helm-system-monorepo.git
        revision: HEAD
  goTemplate: true
  goTemplateOptions:
    - missingkey=error
  template:
    metadata:
      name: "{{ index .path.segments 1 }}"
    spec:
      destination:
        name: "in-cluster"
        namespace: "{{ index .path.segments 1 }}"
      project: "{{ index .path.segments 3 }}"
      revisionHistoryLimit: 3
      sources:
        - repoURL: "{{ .global.repository }}"
          chart: "{{ .global.chart }}"
          targetRevision: "{{ .global.version }}"
          helm:
            releaseName: "{{ index .path.segments 1 }}"
            valueFiles:
              - "$values/global-values.yaml"
              - "$values/charts/{{ index .path.segments 1 }}/values.yaml"
              - "$values/charts/{{ index .path.segments 1 }}/environments/{{ index .path.segments 3 }}/values.yaml"
            values: |
              nameOverride: {{ index .path.segments 1 }}
              fullnameOverride: {{ index .path.segments 1 }}
        - repoURL: https://github.com/jamie-stinson/helm-system-monorepo.git
          targetRevision: HEAD
          ref: values
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
          limit: 5
        syncOptions:
          - Validate=true
          - CreateNamespace=true
          - PrunePropagationPolicy=foreground
          - PruneLast=true
          - ServerSideApply=true
          - RespectIgnoreDifferences=false
          - ApplyOutOfSyncOnly=false
YAML
  depends_on  = [
    helm_release.this,
    kubectl_manifest.project
  ]
}
