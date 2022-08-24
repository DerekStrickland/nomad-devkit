job "prestart" {
  datacenters = ["dc1"]

  group "cache" {
    count = 2

    max_client_disconnect = "2m"

    network {
      port "db" {
        to = 6379
      }
    }

    update {
      min_healthy_time  = "10s"
      healthy_deadline  = "5m"
      progress_deadline = "10m"
    }

    task "wait-for-db" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }

      driver = "exec"
      config {
        command = "sh"
        args = ["-c", "sleep 5 && echo 'running...' && exit 0;"]
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

