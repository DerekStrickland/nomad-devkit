variable "token" {
  type    = string
  default = "411b5a75-333a-45d8-9435-8ea23c9cf63d"
}

locals {
  config-template = <<-EOF
    authtoken ${var.token}
  EOF
}

job "template-with-vars" {
  datacenters = ["dc1"]

  group "cache" {
    count = 3

    max_client_disconnect = "1h"

    constraint {
      attribute = "${attr.kernel.name}"
      value     = "linux"
    }

    constraint {
      operator = "distinct_hosts"
      value    = "true"
    }

    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      template {
        data        = "${local.config-template}"
        destination = "${NOMAD_ALLOC_DIR}/data/password.txt"
        change_mode = "restart"
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

