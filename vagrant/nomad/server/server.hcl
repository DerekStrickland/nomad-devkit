log_level= "TRACE"
datacenter = "dc1"
data_dir = "/etc/nomad.d/data"
enable_debug = true

server {
  enabled = true
  bootstrap_expect = 1
  #server_join {
  #  retry_join = [ "192.168.56.12", "192.168.56.13" ]
  #  retry_max = 3
  #  retry_interval = "15s"
  #}

  #default_scheduler_config {
    # Set a default carbon score in case not all nodes fingerprint it
    #carbon_default_score = 50

    # These weights will enable carbon scoring and prioritize it over
    # binpacking but less than job-anti-affinity
    #scoring_weights = {
      #"job-anti-affinity" = 2
      #carbon              = 1.5
      #binpack             = 0.5
    #}
  #}
}

addresses {
  rpc = "192.168.56.11"
  serf = "192.168.56.11"
}
