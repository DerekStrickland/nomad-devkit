job "artifact-docker" {
  datacenters = ["dc1"]
  
  task "docker-image" {
    driver = "docker"

    config {
      load  = "busybox.tar"
      image = "busybox:1.29.3"
      ports = ["http"]
    }

    artifact {
      source = "https://github.com/hashicorp/nomad/blob/13cc8b3c4aab6bb5071bc8d363256dc2b9972ceb/drivers/docker/test-resources/docker/busybox.tar"
    }
  }

}
