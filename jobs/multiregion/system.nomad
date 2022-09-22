job "multiregion-system" {
  datacenters = ["dc1", "dc2", "dc3"]
  type        = "system"

  multiregion {

    strategy {
      max_parallel = 1
    }

    region "east" {
      count       = 1
      datacenters = ["dc1"]
    }

    region "west" {
      count       = 1
      datacenters = ["dc2"]
    }

    region "north" {
      count       = 1
      datacenters = ["dc3"]
    }

  }

  update {
    max_parallel      = 1
    min_healthy_time  = "10s"
    healthy_deadline  = "2m"
    progress_deadline = "3m"
    auto_revert       = true
    auto_promote      = true
    canary            = 1
    stagger           = "30s"
  }


  group "cache" {

    count = 0

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
