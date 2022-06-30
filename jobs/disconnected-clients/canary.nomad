job "edge" {
  datacenters = ["dc1"]

  group "cache" {
    count = 6

    update {
      max_parallel     = 1
      canary           = 1
      min_healthy_time = "3s"
      healthy_deadline = "20s"
      auto_revert      = true
      auto_promote     = true
    }


    max_client_disconnect = "2m"

    spread {
      attribute = "${node.unique.name}"
      weight    = 100
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

