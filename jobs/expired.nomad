job "expired" {
  datacenters = ["dc1"]

  group "expired" {
    count = 2

    max_client_disconnect = "10s"
    
    spread {
      attribute = "${node.datacenter}"
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

