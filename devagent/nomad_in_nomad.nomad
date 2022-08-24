job "nomad" {
  datacenters = ["dc1"]

  meta {
    version = "2"
  }

  group "us" {
    task "server" {
      driver = "raw_exec"

      config {
        command = "nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/laoqui/license.txt"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "us-server"
region   = "us"

server {
  enabled          = true
  bootstrap_expect = 1
}

ports {
  http = "5646"
  rpc  = "5647"
  serf = "5648"
}
EOF
        destination = "local/config.hcl"
      }
    }

    task "client" {
      driver = "raw_exec"

      config {
        command = "nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/laoqui/license.txt"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "us-client"
region   = "us"

client {
  enabled = true

  server_join {
    retry_join = ["127.0.0.1:5647"]
  }
}

ports {
  http = "5656"
  rpc  = "5657"
  serf = "5658"
}
EOF
        destination = "local/config.hcl"
      }
    }
  }

  group "eu" {
    task "server" {
      driver = "raw_exec"

      config {
        command = "nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/laoqui/license.txt"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "eu-server"
region   = "eu"

server {
  enabled          = true
  bootstrap_expect = 1
}

ports {
  http = "6646"
  rpc  = "6647"
  serf = "6648"
}
EOF
        destination = "local/config.hcl"
      }
    }

    task "client" {
      driver = "raw_exec"

      config {
        command = "nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/laoqui/license.txt"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "eu-client"
region   = "eu"

client {
  enabled = true

  server_join {
    retry_join = ["127.0.0.1:6647"]
  }
}

ports {
  http = "6656"
  rpc  = "6657"
  serf = "6658"
}
EOF
        destination = "local/config.hcl"
      }
    }
  }
}
