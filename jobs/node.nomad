job "spread" {
  datacenters = ["dc1"]

  group "cache" {
    count = 6

    max_client_disconnect = "2m"
    
    spread {
      attribute = "${node.unique.name}"
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
        cpu    = 500
        memory = 256
      }
    }
  }
}

