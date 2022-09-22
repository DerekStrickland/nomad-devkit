job "multiregion-batch-periodic" {
  datacenters = ["dc1", "dc2", "dc3"]
  namespace   = "default"

  multiregion {

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

  type = "batch"

  periodic {
    // Launch every 20 seconds
    cron             = "*/20 * * * * * *"
    prohibit_overlap = "true"
    time_zone        = "CET"
  }

  group "date-group" {
    count = 1

    task "date" {
      driver = "raw_exec"

      service {
        name = "date-batch-job"
        tags = ["date"]
      }

      config {
        command = "/bin/sh"
        args    = ["/Users/derekstrickland/code/nomad-devkit/jobs/multiregion/batch-script.sh"]
      }
    }
  }
}
