# nomadfiles

This is a repository to hold the various [Nomad](https://www.nomadproject.io/) job files I create and use.

## Usage

As a minimum each job file requires the following parameters to be modified to match your cluster setup:
- Region ``` region = "${REGION}" ```
- Datacenters ``` datacenters = ["${DATACENTER_NAME}"] ```

Parameters that require substitution and are specific to the job will be detailed in the job file.
