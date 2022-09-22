job "cores" {
  region = "east"
  datacenters = ["dc1"]
  group "cores" {
    task "cores" {
      driver = "docker"
      resources {
	cores = 1
        memory = 80
      }
      config {
        image = "alpine"
        command = "echo"
        args = [
          "blabla&region=us",
        ]
      }
    }
  }
}
