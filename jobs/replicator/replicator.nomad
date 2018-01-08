# This job will deploy https://github.com/elsevier-core-engineering/replicator
# using the docker driver.
job "replicator" {
  datacenters = ["[[.datacenter]]"]
  region      = "[[.region]]"
  type        = "service"

  update {
    max_parallel     = 1
    min_healthy_time = "20s"
    healthy_deadline = "1m"
    auto_revert      = true
    stagger          = "60s"
  }

  group "replicator" {

    count = 2

    task "replicator" {
      driver = "docker"

      config {
        image        = "elsce/replicator:[[.version]]"
        network_mode = "host"
        args         = ["agent"]
      }

      service {
        name = "replicator"
        tags = ["infra", "[[.version]]"]
      }

      resources {
        cpu    = [[.cpu]]
        memory = [[.memory]]

        network {
          mbits = [[.mbits]]
        }
      }
    }
  }
}
