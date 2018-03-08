job "atlantis" {
  datacenters = ["[[.datacenter]]"]
  region      = "[[.region]]"
  type        = "service"

  group "server" {

    count = 1

    task "server" {

      vault {
        policies    = ["[[.vault_policy]]"]
        change_mode = "restart"
      }

      template {
        data = <<EOH
{{ with vault "[[.vault_path]]" }}
AWS_ACCESS_KEY_ID={{ .Data.access_key }}
AWS_SECRET_ACCESS_KEY={{ .Data.secret_key  }}
{{ end }}
EOH

        destination = "secrets/file.env"
        env         = true
      }

      driver = "docker"

      config {
        image = "hootsuite/atlantis:[[.version]]"

        args  = ["server",
                 "--atlantis-url", "[[.url]]",
                 "--gitlab-hostname", "[[.gitlab_hostname]]",
                 "--gitlab-user", "[[.gitlab_user]]",
                 "--gitlab-token", "[[.gitlab_token]]"]

        port_map {
          http = 4141
        }
      }

      env {
        AWS_DEFAULT_REGION    = "[[.region]]"
      }

      service {
        name = "atlantis"
        port = "http"
        tags = ["ci",
                "[[.version]]",
                "[[.urlprefix]]"]

        check {
          type     = "http"
          path     = "/"
          interval = "20s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = [[.cpu]]
        memory = [[.memory]]

        network {
          mbits = [[.mbits]]
          port "http"{}
        }
      }
    }
  }
}
