job "loki" {
  region      = "global"
  datacenters = ["dc1"]


  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  constraint {
    attribute = "$${attr.unique.hostname}"
    value     = "node-client-1"
  }

  group "loki" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        static = 3100
        to     = 3100
      }

      port "grpc" {
        to = 9095
      }
    }

    service {
      name = "loki"
      port = "http"

      connect {
        sidecar_service {}
      }
    }

    task "loki" {
      driver = "docker"

      config {
        image = "grafana/loki:latest"
      }

      resources {
        cpu    = 200
        memory = 256
      }
    }
  }
}
