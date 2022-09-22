job "vault-secrets-noop" {
  datacenters = ["dc1"]

  vault {
    policies    = ["access-secrets-pki"]
    change_mode = "noop"
  }

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  #  This is optional config. I set this because I always use node2 to test connectivity problems.
  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "node-client-2"
  }

  group "group" {
    count                 = 1
    max_client_disconnect = "1h"

    task "task" {
      driver = "docker"

      config {
        image   = "busybox:1"
        command = "/bin/sh"
        args    = ["-c", "sleep 3000"]
      }

      template {
        data = <<EOT
{{ with secret "devkit-pki/issue/nomad" "common_name=nomad.service.consul" "ip_sans=127.0.0.1" }}
{{- .Data.certificate -}}
{{ end }}
EOT

        destination = "${NOMAD_SECRETS_DIR}/certificate.crt"
        change_mode = "noop"
      }

      template {
        data = <<EOT
      SOME_SECRET={{ with secret "devkit-secrets/data/myapp" }}{{- .Data.data.key -}}{{end}}
      EOT

        destination = "${NOMAD_SECRETS_DIR}/access.key"
        change_mode = "noop"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

  }
}
