job "spread" {
  datacenters = ["dc1"]

  group "cache" {
    count = 12

    max_client_disconnect = "2m"
    
    spread {
      attribute  = "${attr.unique.hostname}"
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
        cpu    = 200
        memory = 128
      }
    }
  }
}

