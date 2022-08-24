job "lifecycle-test" {
  datacenters = ["dc1"]

  group "cache" {
    task "prestart" {
      driver = "raw_exec"

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
touch "${NOMAD_ALLOC_DIR}/lifecycle"
echo "${NOMAD_ALLOC_DIR}/lifecycle"
echo "`date` prestart" >> "${NOMAD_ALLOC_DIR}/lifecycle"
sleep 10
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "prestart_sidecar" {
      driver = "raw_exec"

      lifecycle {
        hook    = "prestart"
        sidecar = true
      }

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
echo "`date` prestart_sidecar" >> "${NOMAD_ALLOC_DIR}/lifecycle"
while true; do
  sleep 1
done
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }


    task "main" {
      driver = "raw_exec"

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
echo "`date` main " >> "${NOMAD_ALLOC_DIR}/lifecycle"
while true; do
  sleep 1
done
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "poststart" {
      driver = "raw_exec"

      lifecycle {
        hook = "poststart"
      }

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
echo "`date` poststart  " >> "${NOMAD_ALLOC_DIR}/lifecycle"
sleep 10
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "poststart_sidecar" {
      driver = "raw_exec"

      lifecycle {
        hook    = "poststart"
        sidecar = true
      }

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
echo "`date` poststart_sidecar  " >> "${NOMAD_ALLOC_DIR}/lifecycle"
while true; do
  sleep 1
done
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }

    task "poststop" {
      driver = "raw_exec"

      lifecycle {
        hook = "poststop"
      }

      config {
        command = "/bin/bash"
        args    = ["local/script.sh"]
      }

      template {
        data        = <<EOF
echo "`date` poststop {{ with secret "devkit-pki/issue/nomad" "common_name=nomad.service.consul" "ip_sans=127.0.0.1" }}
      {{- .Data.certificate -}}
      {{ end }} " >> "${NOMAD_ALLOC_DIR}/lifecycle"
sleep 100
EOF
        destination = "local/script.sh"
      }

      resources {
        cpu    = 50
        memory = 50
      }
    }
  }
}
