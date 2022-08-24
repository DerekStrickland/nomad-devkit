job "edge" {
  datacenters = ["dc1"]

  group "fail" {
    count = 6

    max_client_disconnect = "2m"

    spread {
      attribute = "${attr.unique.hostname}"
    }

    restart {
      attempts = 0
      mode     = "fail"
    }

    task "fail" {
      driver = "docker"

      config {
        image   = "busybox:1"
        command = "sh"
        args    = ["/local/script.sh"]
      }

      resources {
        cpu    = 100
        memory = 64
      }

      template {
        data        = <<EOF
#!/usr/bin/env bash

hostname={{ env "attr.unique.hostname" }}
echo $hostname
sleep 30
while true
do
  if [ "$hostname" = "nomad-client02" ] 
  then
	echo "exiting $hostname" 
    exit 1
  else 
    echo "running $hostname"
    sleep 1
  fi
done
        EOF
        destination = "local/script.sh"
      }
    }
  }
}
