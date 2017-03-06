# This job will deploy https://github.com/jippi/hashi-ui using the
# docker driver.
#
# Parameters:
#   - HASHIUI_URLPREFIX : the fabio urlprefix to use for this job
job "hashi-ui" {
  datacenters = ["${DATACENTER_NAME}"]
  region      = "${REGION}"
  type        = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "hashi-ui" {
    count = 1

    task "hashi-ui" {
      constraint {
        attribute = "${attr.kernel.name}"
        value     = "linux"
      }

      driver = "docker"

      config {
        image = "jippi/hashi-ui:v0.13.1"

        port_map {
          http = 3000
        }
      }

      service {
        name = "hashi-ui"
        tags = ["http", "ui", "urlprefix-${HASHIUI_URLPREFIX}"]

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
        cpu    = 500
        memory = 512

        network {
          mbits = 1
          port  "http"{}
        }
      }
    }
  }
}
