# This job will deploy https://github.com/jrasell/dashboard-duty using the
# docker driver.
#
# Parameters:
#   - DASHBOARD_DUTY_SERVICE   : name of the PD service you wish to display
#   - DASHBOARD_DUTY_KEY       : a V2, Read-Only PagerDuty API key
#   - DASHBOARD_DUTY_URLPREFIX : the fabio urlprefix to use for this job
job "dashboard-duty" {
  datacenters = ["${DATACENTER_NAME}"]
  region      = "${REGION}"
  type        = "service"

  update {
    stagger      = "30s"
    max_parallel = 1
  }

  group "dashbaord-duty" {
    count = 1

    task "dashbaord-duty" {
      constraint {
        attribute = "${attr.kernel.name}"
        value     = "linux"
      }

      driver = "docker"

      config {
        image = "jrasell/dashboard-duty:0.0.2"

        port_map {
          http = 5000
        }
      }

      service {
        name = "dashboard-duty"
        tags = ["http", "urlprefix-${DASHBOARD_DUTY_URLPREFIX}"]

        port = "http"

        check {
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      env {
        DASHBOARD_DUTY_SERVICE = "${DASHBOARD_DUTY_SERVICE}"
        DASHBOARD_DUTY_KEY     = "${DASHBOARD_DUTY_KEY}"
      }

      resources {
        cpu    = 250
        memory = 60

        network {
          mbits = 1
          port  "http"{}
        }
      }
    }
  }
}
