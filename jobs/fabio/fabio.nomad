# This is an example nomad job file which can be used to run fabio on your
# cluster as a system task. This ensures it will run on all nomad nodes which
# have avaiable resources.
job "fabio" {
  datacenters = ["[[.datacenter]]"]
  region      = "[[.region]]"
  type        = "system"

  update {
    stagger      = "60s"
    max_parallel = 1
  }

  group "fabio" {

    task "fabio" {
      constraint {
        attribute = "${attr.kernel.name}"
        value     = "linux"
      }

      driver = "exec"

      config {
        command = "./[[.binary_name]]"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/[[.version]]/[[.binary_name]]"
      }

      service {
        name = "fabio-http"
        tags = ["http", "load-balancer", "[[.version]]"]

        port = "http"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      service {
        name = "fabio-ui"
        tags = ["ui", "load-balancer", "[[.version]]"]

        port = "ui"

        check {
          type     = "http"
          path     = "/"
          interval = "30s"
          timeout  = "3s"
        }
      }

      resources {
        cpu    = [[.cpu]]
        memory = [[.memory]]

        network {
          mbits = [[.mbits]]

          # Fabio acts as the routing layer therefore static ports are used for
          # both the http and ui ports.
          port "http" {
            static = 9999
          }

          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}
