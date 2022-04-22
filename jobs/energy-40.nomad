job "energy" {
  datacenters = ["dc1"]

  constraint {
    attribute = "${attr.energy.carbon_score}"
    operator  = "<"
    value     = "60"
  }

  group "cache" {
    count = 2

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

