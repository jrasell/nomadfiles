# nomadfiles

Continuous delivery examples for Nomad jobs.

This is a repository to hold the various [Nomad](https://www.nomadproject.io/) job files I create and use. Included is also the corresponding [Jenkinsfile](https://jenkins.io/doc/book/pipeline/jenkinsfile/) for automated deployments and the [Jenkins JobDSL](https://github.com/jenkinsci/job-dsl-plugin) file for configuring the Jenkins job.

This project sacrifices [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself) in order to make the structure and usage clearer.

## Nomad Job Files

The `.nomad` files contained within this repository will require some slight changes to be compatible with alternative clusters. The particular parameters are:
- **`datacenters`** - A list of datacenters in the region which are eligible for task placement. This must be provided, and does not have a default.
- **`region`** - The region in which to execute the job.

### Parameters

Currently Nomad job files [do not support interpolation in all fields](https://groups.google.com/forum/#!topic/nomad-tool/wD5ZzQtlfaI), therefore as a work around for the deployment job, this project uses parameters `NOMAD_PARAM_*` as specially identified parameters which will be substituted at deployment time. These parameters correlate directly to the Jenkins parameterized builds.

## Jenkins JobDSL

The `.groovy` files which are co-located with the Nomad job files are Jenkins JobDSL which can be used to configure the deployment job correctly and in an automated, codified manner. Details about the JobDSL plugin and basic usage information can be found on the [GitHub](https://github.com/jenkinsci/job-dsl-plugin).

## Jenkinsfile

A Jenkinsfile is a text definition of the unit of work which the Jenkins deployment job will undertake. The Nomad deployments use the [djenriquez/nomad](https://hub.docker.com/r/djenriquez/nomad/) docker image to run Docker commands using the [-address=](https://www.nomadproject.io/docs/commands/run.html#_address_lt_addr_gt_) flag to ensure commands are run against the correct cluster.

As mentioned previously, Nomad does not support interpolation in all fields, therefore the deployment runs use [sed](https://www.gnu.org/software/sed/manual/sed.html) to perform lightweight job file manipulations based on job parameters.

All [non-system Nomad types](https://www.nomadproject.io/docs/runtime/schedulers.html) will have a deployment job parameter of `count` which sets the initial count of the job group and is only required for the initial deployment. Subsequent deployments will use the current Nomad state of the job to determine this as it is expected the cluster is running some form of autoscaling.

## Contributing

Any contributions are much appreciated. Submit Pull Requests and Issues to the [nomadfiles project on GitHub](https://github.com/jrasell/nomadfiles).
