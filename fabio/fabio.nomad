# This is an example nomad job file which can be used to run fabio on your
# cluster as a system task. This ensures it will run on all nomad nodes which
# have avaiable resources.
job "fabio" {
  datacenters = ["jrasell"]
  region      = "london"
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
        command = "./NOMAD_PARAM_fabio_command"
      }

      artifact {
        source = "https://github.com/eBay/fabio/releases/download/vNOMAD_PARAM_fabio_version/NOMAD_PARAM_fabio_command"
      }

      service {
        name = "fabio"
        tags = ["http", "load-balancer"]

        port = "http"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500
        memory = 512

        network {
          mbits = 1

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
