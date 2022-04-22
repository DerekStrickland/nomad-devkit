job "spread" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2

    max_client_disconnect = "5m"
    
    spread {
      attribute = "${node.datacenter}"
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
        cpu    = 500
        memory = 256
      }
    }
  }
}

