def hashiui_envs = [
            'prod':'nomad.jrasell.com',
            'nonprod':'nomad.np.jrasell.com'
            ]

for (env in hashiui_envs) {
      pipelineJob("nomad_deploy_${env.key}_hashi-ui") {
          parameters {
          stringParam("nomad_url", "${env.value}", 'the URL of the Nomad HTTP API endpoint')
      }

      definition{
          cpsScm {
              scm {
                  git {
                      branches('master')
                      remote {
                          url('https://github.com/jrasell/nomadfiles.git')
                      }
                  }
              }
              scriptPath("./jobs/hashi-ui/Jenkinsfile")
            }
        }
    }
}
