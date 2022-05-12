job "csitest" {
  datacenters = ["dc1"]

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    stagger = "30s"
  }

  group "csitest" {
    count = 3

    volume "csitest" {
      type = "csi"
      source = "csitest"
      attachment_mode = "file-system"
      access_mode = "single-node-writer"
      per_alloc = true
    }

    task "csitest" {
      driver = "docker"

      config {
        image = "python:3.7-alpine"
        entrypoint = ["sleep", "infinity"]
        dns_servers = ["172.17.0.1"]
      }

      volume_mount {
        volume = "csitest"
        destination = "/vol"
      }

      resources {
        memory = 128
      }
    }
  }
}

