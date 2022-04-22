job "stop-after" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2

    stop_after_client_disconnect = "15s"
    max_client_disconnect = "1h"
    
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

