# This is an example nomad job file which can be used to run fabio on your
# cluster as a system task. This ensures it will run on all nomad nodes which
# have avaiable resources.
job "fabio" {
  datacenters = ["${DATACENTER_NAME}"]
  region      = "${REGION}"
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
        command = "./fabio-1.3.7-go1.7.4-linux_amd64"
      }

      artifact {
        source = "https://github.com/eBay/fabio/releases/download/v1.3.7/fabio-1.3.7-go1.7.4-linux_amd64"

        options {
          checksum = "sha256:3ddc4493b1b605f885212907fc4d16d350fb9d8f1f01dc064f0ad2083a0a8a1e"
        }
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
        memory = 60

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
