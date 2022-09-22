job "batch-not-periodic" {
  datacenters = ["dc1"]
  namespace   = "default"

  type = "batch"

  group "date-batch-script" {
    count = 1

    task "date" {
      driver = "raw_exec"

      service {
        name = "date-batch-job"
        tags = ["date"]
      }

      config {
        command = "/bin/sh"
        args    = ["/vagrant/script/batch-script.sh"]
      }
    }
  }
}
