job "csitest" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    stagger = "30s"
  }

  group "csitest" {
    count = 3

    task "csitest" {
      driver = "docker"

      config {
        image = "python:3.7-alpine"
        entrypoint = ["sleep", "infinity"]
        dns_servers = ["172.17.0.1"]
      }

      resources {
        memory = 128
      }
    }
  }
}

