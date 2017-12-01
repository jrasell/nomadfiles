# This job will deploy https://github.com/jippi/hashi-ui using the
# docker driver.
job "hashi-ui" {
  datacenters = ["[[.datacenter]]"]
  region      = "[[.region]]"
  type        = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "hashi-ui" {
    count = 1

    task "hashi-ui" {

      driver = "docker"

      config {
        image = "jippi/hashi-ui:[[.version]]"

        port_map {
          http = 3000
        }
      }

      service {
        name = "hashi-ui"
        tags = ["http", "ui", "urlprefix-[[.urlprefix]]", "[[.version]]"]

        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        NOMAD_ENABLE = 1
        NOMAD_ADDR   = "http://nomad.service.consul:4646"
      }

      resources {
        cpu    = [[.cpu]]
        memory = [[.memory]]

        network {
          mbits = [[.mbits]]
          port  "http"{}
        }
      }
    }
  }
}
