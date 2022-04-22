job "disco-service" {

  datacenters = ["dc1"]

  type = "service"

  group "app" {
    count = 6

    max_client_disconnect = "2m"

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
        cpu    = 200
        memory = 256
      }
    }

    task "redis" {
      driver = "docker"
      template {
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
        cpu    = 500
        memory = 256
      }
    }
  }
}
