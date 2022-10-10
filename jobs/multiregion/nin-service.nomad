job "nin-multiregion-service" {
  datacenters = ["dc1"]
  type        = "service"

  multiregion {

    strategy {
      max_parallel = 1
      on_failure   = "fail_all"
    }

    region "us" {
      count       = 1
      datacenters = ["dc1"]
    }

    region "eu" {
      count       = 1
      datacenters = ["dc2"]
    }

  }

  // constraint {
  //   distinct_hosts = true
  // }

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

    count = 1

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
        cpu    = 50
        memory = 50
      }
    }
  }
}
