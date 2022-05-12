# Nomad Vagrant Environment Setup

Host machine
Install Vagrant
Install Virtualbox

```shell
mkdir -p /opt/gopath/src/github.com/hashicorp
sudo chown <username> /opt/gopath/src
cd /opt/gopath/src/github.com/hashicorp
git clone https://github.com/hashicorp/nomad
cd nomad
vagrant up linux nomad-server01 nomad-client01
# Get coffee
vagrant status
vagrant ssh linux
make bootstrap
make dev
exit 
```

## Single Server Setup

nomad-server01

`vagrant ssh nomad-server01`

When you ssh in you should be in the /opt/gopath/src/github.com/hashicorp/nomad directory

```shell
sudo mkdir -p /opt/gopath/bin
sudo cp bin/nomad /opt/gopath/bin/nomad
sudo mkdir -p /etc/nomad.d/data
sudo chown vagrant /etc/nomad.d
vim /etc/nomad.d/server.hcl
```

```hcl
log_level= "DEBUG"
datacenter = "dc1"
data_dir = "/etc/nomad.d/data"
enable_debug = true

server {
  enabled = true
  bootstrap_expect = 1
}

addresses {
  rpc = "192.168.56.11"
  serf = "192.168.56.11"
}
```

`sudo vim /etc/systemd/system/nomad.service`

```shell
[Unit]
Description=Nomad Service
Requires=network-online.target
After=network-online.target

[Service]
LimitAS=infinity
LimitRSS=infinity
LimitCORE=infinity
LimitNOFILE=infinity
User=root
EnvironmentFile=-/etc/sysconfig/nomad
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/opt/gopath/bin/nomad agent $OPTIONS -config=/etc/nomad.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl enable nomad
go install github.com/go-delve/delve/cmd/dlv@latest
```

## Client Setup

`vagrant ssh nomad-client01`

When you ssh in you should be in the /opt/gopath/src/github.com/hashicorp/nomad directory

```shell
cp bin/nomad /opt/gopath/bin/nomad
sudo which nomad to make sure this binary was copied
sudo mkdir /etc/nomad.d/data
sudo chown vagrant /etc/nomad.d
vim /etc/nomad.d/client.hcl
```

```hcl
log_level= "DEBUG"
datacenter = "dc1"
data_dir = "/etc/nomad.d/data"
enable_debug = true

client {
  enabled = true
  server_join {
    retry_join = ["192.168.56.11"]
  }
}
```

`sudo vim /etc/systemd/system/nomad.service`

```shell
[Unit]
Description=Nomad Service
Requires=network-online.target
After=network-online.target

[Service]
LimitAS=infinity
LimitRSS=infinity
LimitCORE=infinity
LimitNOFILE=infinity
User=root
EnvironmentFile=-/etc/sysconfig/nomad
Environment=GOMAXPROCS=2
Restart=on-failure
ExecStart=/opt/gopath/bin/nomad agent $OPTIONS -config=/etc/nomad.d
ExecReload=/bin/kill -HUP $MAINPID
KillSignal=SIGINT
StandardOutput=journal

[Install]
WantedBy=multi-user.target
```

```shell
sudo systemctl enable nomad
```

## Client Setup w/Consul Template

```hcl
log_level= "DEBUG"
datacenter = "dc1"
data_dir = "/etc/nomad.d/data"
enable_debug = true

client {
  enabled = true
  server_join {
    retry_join = ["192.168.56.11"]
  }

  template {
    block_query_wait = "30s"
    max_stale = "5m"

    wait {
      min = "5s"
      max = "10s"
    }

    wait_bounds {
      min = "3s"
      max = "1h"
    }

    consul_retry {
      attempts = 12
      backoff = "250ms"
      max_backoff = "1m"
    }

    vault_retry {
      attempts = 15
      backoff = "350ms"
      max_backoff = "21m"
    }
  }
}
```

## IDE Setup

vagrant ssh-config nomad-client01 to get SSH configuration for setting up IDE

sudo dlv --listen=:7200 --headless=true --api-version=2 --accept-multiclient exec ./bin/nomad agent -- --config=/etc/nomad.d

Live Reloads
dlv debug

Use the following debug subcommand to potentially allow dlv reload if that’s a better option than the medium article below

sudo dlv debug ./ --listen=:7200 --headless=true --api-version=2 --accept-multiclient -- agent --config=/etc/nomad.d

inotify 

Blog post for docker workflow. Could be adapted to Vagrant.

https://medium.com/@hananrok/debugging-hot-reloading-go-app-within-docker-container-b44d2929e8bd

Source url: https://github.com/hanrok/godebug

References

dlv cli official commands
https://github.com/go-delve/delve/tree/master/Documentation/cli

Using dlv debug https://www.jamessturtevant.com/posts/Using-the-Go-Delve-Debugger-from-the-command-line/

Issue for dlv reload command for live debugging
https://github.com/go-delve/delve/issues/1551

Vagrant Machine Provisioning Requirements

Use Packer
Ubuntu Minimal Server - https://cloud-images.ubuntu.com/focal/20220113/
Go added to the image.
Delve added to the image.
Make deps during provisioning.
Add Java, QEMU, docker, containerd, see scripts folder for all the individual provisioners.
Do it once, and then the other Vagrant boxes use the single image.
Add a way to start up the Delve server vs the standard binary
Tunables for Consul/Vault - enable/disable, select version.
Install the nomad package from APT to get default binary, systemd & config files?
Figure out how to override the default binary with the built binary.
Figure out file watcher solution for updating running delve sessions after file save

