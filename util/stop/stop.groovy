def util_envs = [
            'prod':'nomad.jrasell.com'
            'nonprod': 'nomad.np.jrasell.com'
            ]

for (env in util_envs) {
      pipelineJob("nomad_util_${env.key}_stop") {
          parameters {
          stringParam("job_name", '', 'the Nomad job to stop')
          stringParam("nomad_url", "${env.value}", 'the URL of the Nomad HTTP API endpoint')
          booleanParam('purge', false, 'run the purge flag with the stop command')
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
              scriptPath("./jobs/util-stop/Jenkinsfile")
            }
        }
    }
}
