job "multiregion-batch-not-periodic" {
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
