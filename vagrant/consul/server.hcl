vagrant@nomad-server01:/opt/gopath/src/github.com/hashicorp/nomad$ cat /etc/consul.d/server.hcl
server =  true
bootstrap_expect = 1
log_level = "DEBUG"
data_dir = "/etc/consul.d/data"
bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"
advertise_addr = "{{ GetPrivateIP }}"
ui     =  true

service {
  name  =  "consul"
}

connect {
  enabled = true
}

ports {
  http = -1,
  https = 8501,
  grpc =  8502
}

