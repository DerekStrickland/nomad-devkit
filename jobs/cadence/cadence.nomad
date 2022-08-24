job "cadence" {
  datacenters = ["dc1"]
  type        = "service"

  constraint {
    attribute = "${attr.unique.hostname}"
    value     = "node-client-1"
  }

  group "cadence" {
    count                 = 1
    max_client_disconnect = "1d"

    network {
      mode = "bridge"

      port "cassandra" {
        static = 9042
        to     = 9042
      }

      port "prometheus" {
        static = 9090
        to     = 9090
      }

      port "node-exporter" {
        static = 9100
        to     = 9100
      }

      port "grafana" {
        static = 3000
        to     = 3000
      }

      port "cadence-7933" {
        static = 7933
        to     = 7933
      }

      port "cadence-7934" {
        static = 7934
        to     = 7934
      }

      port "cadence-7935" {
        static = 7935
        to     = 7935
      }

      port "cadence-7939" {
        static = 7939
        to     = 7939
      }

      port "cadence-7833" {
        static = 7833
        to     = 7833
      }

      port "cadence-prometheus-0" {
        static = 8000
        to     = 8000
      }

      port "cadence-prometheus-1" {
        static = 8001
        to     = 8001
      }

      port "cadence-prometheus-2" {
        static = 8002
        to     = 8002
      }

      port "cadence-prometheus-3" {
        static = 8003
        to     = 8003
      }

      port "cadence-web" {
        static = 8088
        to     = 8088
      }
    }

    task "cassandra" {
      driver = "docker"
      config {
        image = "cassandra:3.11"
        port  = "cassandra"
      }

      network {
        mode = "bridge"
      }
    }

    task "prometheus" {
      driver = "docker"
      config {
        image = "prom/prometheus:latest"
        port  = "prometheus"
        args  = ["--config.file=/etc/prometheus/prometheus.yml"]
      }

      network {
        mode = "bridge"
      }

      # volumes: ./prometheus:/etc/prometheus
    }

    task "node-exporter" {
      driver = "docker"
      config {
        image = "prom/node-exporter:latest"
        port  = "node-exporter"
      }

      network {
        mode = "bridge"
      }
    }

    task "cadence" {
      driver = "docker"
      config {
        image = "ubercadence/server:master-auto-setup"
        ports = ["cadence-7933", "cadence-7934", "cadence-7935", "cadence-7939", "cadence-7833", "cadence-prometheus-0", "cadence-prometheus-1", "cadence-prometheus-2", "cadence-prometheus-3"]
      }

      network {
        mode = "bridge"
      }

      env {
        environment :
        -"CASSANDRA_SEEDS=cassandra"
        -"PROMETHEUS_ENDPOINT_0=0.0.0.0:8000"
        -"PROMETHEUS_ENDPOINT_1=0.0.0.0:8001"
        -"PROMETHEUS_ENDPOINT_2=0.0.0.0:8002"
        -"PROMETHEUS_ENDPOINT_3=0.0.0.0:8003"
        -"DYNAMIC_CONFIG_FILE_PATH=config/dynamicconfig/development.yaml"
        depends_on :
      }
    }

    task "cadence-web" {
      driver = "docker"
      config {
        image = "ubercadence/web:latest"
        ports = ["cadence-web"]
      }

      env {
        -"CADENCE_TCHANNEL_PEERS=cadence:7933"
      }
    }

    grafana :
    image : grafana / grafana
    user : "1000"
    depends_on :
    -prometheus
    ports :
    -' 3000 : 3000 '
  }
}
