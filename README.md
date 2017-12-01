# nomadfiles

Continuous delivery examples for Nomad jobs.

This is a repository to hold the various [Nomad](https://www.nomadproject.io/) job files I create and use. Included is also the corresponding [Jenkinsfile](https://jenkins.io/doc/book/pipeline/jenkinsfile/) for automated deployments and the [Jenkins JobDSL](https://github.com/jenkinsci/job-dsl-plugin) file for configuring the Jenkins job.

This project sacrifices [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself) in order to make the structure and usage clearer.

## Levant

This example repository is configured to use [Levant](https://github.com/jrasell/levant), an open source templating and deployment tool for HashiCorp Nomad jobs that provides realtime feedback and detailed failure messages upon deployment issues. Levant was written because Nomad does not support some important templating and deployment features, and this repository represents a simple way to use the tool in a large scale, multi-environment setup.

## Directory Structure

The directory structure is designed to be easy to navigate, yet highly descriptive of your Nomad deployments throughout you environments.

### Jobs Directory

The `/jobs` holds the Nomad job specification and deployment scripts. The directory is split into sub-directories named by the Nomad job.

* **job-name.groovy** The `.groovy` files are Jenkins JobDSL which can be used to configure the deployment job correctly and in an automated, codified manner. Details about the JobDSL plugin and basic usage information can be found on the [GitHub](https://github.com/jenkinsci/job-dsl-plugin) page.

* **job-name.nomad** The Nomad job specification template file.

* **Jenkinsfile** A Jenkinsfile is a text definition of the unit of work which the Jenkins deployment job will undertake.

### Variables Directory

The `/variables` directory holds environment specific variables for each Nomad job. The directory can be split to better suit your needs, in this example, it is split by environment like `/variables/prod`. Within the subdirectory sits the variables files which correspond to a job that is held within the `/jobs` directory.

The variables configured for the nonprod environment should work in a local development setup when Nomad is run with `nomad agent -dev`.

### Util Directory

The `/util` directory contains utility scripts which can be used from CI infrastructure to run common tasks on the desired job such as stop.

## Contributing

Any contributions are much appreciated. Please submit Pull Requests and Issues to the [nomadfiles project on GitHub](https://github.com/jrasell/nomadfiles).
