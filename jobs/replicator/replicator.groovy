def replicator_envs = [
            'prod':'nomad.jrasell.com',
            'nonprod':'nomad.np.jrasell.com'
            ]

for (env in replicator_envs) {
      pipelineJob("nomad_deploy_${env.key}_replicator") {
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
              scriptPath("./jobs/replicator/Jenkinsfile")
            }
        }
    }
}
