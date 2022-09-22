job "contains-any" {
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    attribute = "${meta.machine-role}"
    operator  = "set_contains_any"
    value     = "admin-server,network-server"
  }

  // spread {
  //   attribute = "${attr.unique.hostname}"
  // }

  constraint {
    operator  = "distinct_property"
    attribute = "${meta.machine-role}"
    value     = "1"
  }

  group "cache" {
    count = 2

    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:6.0"

        ports = ["db"]
      }

      resources {
        cpu    = 256
        memory = 128
      }
    }
  }
}
