job "example" {
  datacenters = ["dc1"]

  group "cache" {
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      template {
        data        = "---\nkey: {{ key \"foo\" }}"
        destination = "local/file.yml"

        wait {
          min = "1s"
          max = "2h"
        }
      }

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

