job "nomad" {
  datacenters = ["dc1"]

  group "us" {
    task "server" {
      driver = "raw_exec"

      config {
        command = "/Users/code/nomad-nin-debug/nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/code/nomad.hclic"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "us-server"
region   = "us"
datacenter = "dc1"
log_level  = "TRACE"

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
        command = "/Users/code/nomad-nin-debug/nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/code/nomad.hclic"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "us-client"
region   = "us"
datacenter = "dc1"
log_level  = "TRACE"

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
    task "federate" {

      lifecycle {
        hook    = "poststart"
        sidecar = false
      }

      driver = "raw_exec"

      config {
        command = "bash"
        args = [
          "local/federate.sh",
        ]
      }

      template {
        data        = <<EOF
#!/bin/bash

for i in {1..20}
do
  if NOMAD_ADDR="http://127.0.0.1:6646" nomad server join 127.0.0.1:5648; then
    exit 0
  else
    sleep 5
  fi
done
EOF
        destination = "local/federate.sh"
      }
    }


    task "server" {
      driver = "raw_exec"

      config {
        command = "/Users/code/nomad-nin-debug/nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/code/nomad.hclic"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "eu-server"
region   = "eu"
datacenter = "dc2"
log_level  = "TRACE"

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
        command = "/Users/code/nomad-nin-debug/nomad"
        args    = ["agent", "-config", "local/config.hcl"]
      }

      env {
        NOMAD_LICENSE_PATH = "/Users/code/nomad.hclic"
      }

      template {
        data        = <<EOF
data_dir = "{{env "NOMAD_TASK_DIR"}}/data"
name     = "eu-client"
region   = "eu"
datacenter = "dc2"
log_level  = "TRACE"

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