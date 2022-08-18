job "consul-key-kill" {
  datacenters = ["dc1"]

  group "cache" {
    count = 3

    max_client_disconnect = "1h"

    spread {
      attribute = "{node.unique.name}"
    }

    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      template {
        error_mode  = "kill"
        change_mode = "noop"
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

