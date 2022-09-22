job "system" {
  datacenters = ["dc1"]

  type = "system"

  group "cache" {
    count = 1

    max_client_disconnect = "2m"

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

