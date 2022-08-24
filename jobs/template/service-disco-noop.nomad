job "service-disco-noop" {

  datacenters = ["dc1"]

  type = "service"

  #  This is optional config. I set this because I always use node2 to test connectivity problems.
  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "node-client-2"
  }

  group "app" {
    count = 1

    max_client_disconnect = "21h"

    spread {
      attribute = "{node.unique.name}"
    }

    network {
      port "http" {
        to = 8000
      }
    }

    restart {
      attempts = 2
      interval = "30m"
      delay    = "15s"
      mode     = "fail"
    }

    task "server" {
      driver = "docker"

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
      }

      service {
        name     = "disco"
        port     = "http"
        provider = "nomad"
      }

      resources {
        cpu    = 128
        memory = 128
      }
    }

    task "redis" {
      driver = "docker"
      template {
        change_mode = "noop"
        destination = "local/file.yml"
        data        = <<EOH
http {
  server {
    listen 80;
    location / {
    {{ range nomadService "disco" }}
      proxy_pass http://{{ .Address }}:{{ .Port }};
    {{ end }}
    }
  }
}
  EOH
      }

      config {
        image = "redis:3.2"
      }

      resources {
        cpu    = 128
        memory = 128
      }
    }
  }
}
