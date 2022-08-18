datacenter = "dc1"
log_level  = "TRACE"
data_dir   = "/Users/derekstrickland/nomad/data"

# See https://www.nomadproject.io/docs/faq#q-how-to-connect-to-my-host-network-when-using-docker-desktop-windows-and-macos for more information
bind_addr = "0.0.0.0"
# network_interface = "en0"

acl {
  enabled    = true
  token_ttl  = "30s"
  policy_ttl = "60s"
}

server {
  enabled = true
}

# TODO: set this from envar since not everyone will use a mac or need to use a specific network interface
// consul {
//   address = "172.20.10.2:8500"
// }

// vault {
//   enabled = true
//   address = "http://127.0.0.1:8200"
// }

ui {
  enabled = true

  //   consul {
  //     ui_url = "http://127.0.0.1:8500/ui"
  //   }

  //   vault {
  //     ui_url = "http://127.0.0.1:8200/ui"
  //   }
}

client {
  enabled = true
  //   template {
  //     error_mode       = "noop"
  //     max_stale        = "0s"
  //     block_query_wait = "10s"

  //     wait {
  //       min = "2s"
  //       max = "5s"
  //     }

  //     wait_bounds {
  //       min = "2s"
  //       max = "5s"
  //     }

  //     consul_retry {
  //       attempts    = 1
  //       backoff     = "2s"
  //       max_backoff = "5s"
  //     }

  //     vault_retry {
  //       attempts    = 1
  //       backoff     = "2s"
  //       max_backoff = "5s"
  //     }
  //   }

  # cni_path = "/opt/cni/bin"
}

plugin "docker" {
  config {
    extra_labels = ["job_name", "job_id", "task_group_name", "task_name", "namespace", "node_name", "node_id"]
    volumes {
      enabled = true
    }
  }
}

telemetry {
  collection_interval = "5s"
  disable_hostname    = false
}
