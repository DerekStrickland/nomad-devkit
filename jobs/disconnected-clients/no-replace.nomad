job "edge" {
  datacenters = ["dc1"]

  group "cache" {
    count = 6

    max_client_disconnect = "2m"

    constraint {
      attribute = "${node.unique.name}"
      value     = "nomad-client02"
      operator  = "="
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

