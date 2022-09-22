job "batch-periodic" {
  datacenters = ["dc1"]
  namespace   = "default"

  type = "batch"

  periodic {
    // Launch every 20 seconds
    cron             = "*/20 * * * * * *"
    prohibit_overlap = "true"
    time_zone        = "CET"
  }

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
