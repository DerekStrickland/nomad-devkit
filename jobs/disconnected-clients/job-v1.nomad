job "edge" {
  datacenters = ["dc1"]

  group "cache" {
    count = 6

    max_client_disconnect = "5m"

    spread {
      attribute = "${attr.unique.hostname}"
    }

    network {
      port "db-update" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        ports = ["db-update"]
      }

      resources {
        cpu    = 100
        memory = 64
      }
    }
  }
}

