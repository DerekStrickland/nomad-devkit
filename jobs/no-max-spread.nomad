job "no-max-spread" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2
    
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

