variable "password-file" {
  type = string
}

locals {
  config-template = <<-EOF
    authtoken {{ file "/etc/nomad.d/password.txt" }}
  EOF
}

job "template-with-vars" {
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
        source      = var.password-file
        destination = "${NOMAD_ALLOC_DIR}/data/password.txt"
        change_mode = "restart"
      }

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

