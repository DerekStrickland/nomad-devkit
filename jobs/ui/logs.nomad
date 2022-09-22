job "logs" {
  region = "east"
  datacenters = ["dc1"]
  group "test" {
    task "test" {
      driver = "docker"
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
