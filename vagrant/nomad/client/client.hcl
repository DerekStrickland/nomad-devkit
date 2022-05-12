vagrant@nomad-client01:/opt/gopath/src/github.com/hashicorp/nomad$ cat /etc/nomad.d/client.hcl
log_level= "TRACE"
datacenter = "dc1"
data_dir = "/etc/nomad.d/data"
enable_debug = true

plugin "docker" {
  enabled = true
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

client {
  enabled = true
  server_join {
    retry_join = ["192.168.56.11"]
  }

  template {
    max_stale        = "5s"
    block_query_wait = "90s"

    wait {
      min = "2s"
      max = "60s"
    }

    wait_bounds {
      min = "2s"
      max = "60s"
    }

    consul_retry {
      attempts    = 5
      backoff     = "5s"
      max_backoff = "10s"
    }

    vault_retry {
      attempts    = 10
      backoff     = "15s"
      max_backoff = "20s"
    }
  }

  #energy {
  #  provider = "carbon-intensity"
  #  region   = "UK"

  #  carbon_intensity {
  #    api_url = "https://api.carbonintensity.org.uk/intensity"
  #  }
  #}
}

