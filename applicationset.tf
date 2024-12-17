resource "argocd_application_set" "this" {
  metadata {
    name      = "this"
    namespace = "argocd"
  }

  spec {
    generator {
      git {
        file {
          path = "charts/*/environments/${var.environment}/*/values.yaml"
        }
        repo_url = "https://github.com/jamie-stinson/helm-system-monorepo"
        revision = "HEAD"
      }
    }

    go_template         = true
    go_template_options = ["missingkey=error"]

    template {
      metadata {
        name = "{{ index .path.segments 1 }}-{{ index .path.segments 3 }}"
      }

      spec {
        destination {
          name      = "{{ index .path.segments 3 }}"
          namespace = "{{ index .path.segments 4 }}"
        }

        revision_history_limit = 3

        source {
          repo_url        = "{{ .global.repository }}"
          chart           = "{{ .global.chart }}"
          target_revision = "{{ .global.version }}"

          helm {
            release_name = "{{ index .path.segments 1 }}"

            value_files = [
              "$values/charts/{{ index .path.segments 1 }}/global-values.yaml",
              "$values/charts/{{ index .path.segments 1 }}/environments/{{ index .path.segments 3 }}/{{ index .path.segments 4 }}/values.yaml"
            ]
          }
        }

        source {
          repo_url        = "https://github.com/jamie-stinson/helm-system-monorepo"
          target_revision = "HEAD"
          ref             = "values"
        }

        sync_policy {
          automated {
            allow_empty = true
            prune       = true
            self_heal   = true
          }

          retry {
            backoff {
              duration     = "5s"
              factor       = 2
              max_duration = "3m"
            }
            limit = 5
          }

          sync_options = [
            "Validate=true",
            "CreateNamespace=true",
            "PrunePropagationPolicy=foreground",
            "PruneLast=true",
            "ServerSideApply=true",
            "RespectIgnoreDifferences=false",
            "ApplyOutOfSyncOnly=false"
          ]
        }
      }
    }
  }
}
