job "dns" {
  datacenters = ["dc1"]

  group "dns-test" {
    count = 1

    network {
      mode = "bridge"

      port "http" {
        to = "8080"
      }

      port "gossip" {
        to = "8081"
      }

      dns {
        servers = ["${attr.unique.network.ip-address}"]
      }
    }

    task "dns-test" {
      driver = "docker"

      config {
        image = "python:3.7-alpine"
        entrypoint = ["sleep", "infinity"]
      }
    }
  }
}

