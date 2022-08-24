job "edge" {
  datacenters = ["dc1"]

  group "expired" {
    count = 6

    max_client_disconnect = "10s"

    spread {
      attribute = "${attr.unique.hostname}"
    }

    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        ports = ["db"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}

