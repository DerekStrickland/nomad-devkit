job "gateway-test" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2

    network {
      mode = "bridge"
      port "inbound" {
        static = 8181
        to     = 8181
      }
    }

    service {
      name = "frontend-lb-ingress-gateway"
      port = "8181"

      connect {
        sidecar_task {
          name = "frontend-lb-ingress-gateway-infra"
        }
        gateway {
          proxy {}
          ingress {
            tls {
              enabled = false
            }

            listener {
              port     = 8181
              protocol = "http"
              service {
                name = "*"
              }
            }
          }
        }
      }
    }
  }

  task "redis" {
    driver = "docker"

    config {
      image = "redis:3.2"

      ports = ["db"]
    }

    resources {
      cpu    = 500
      memory = 256
    }
  }
}

