# GCS Pull Deploy (gcs-pd)

This is a sample implementation of the PULL deployment model in GCP, using GCS as a repository for deployment configuration and artefacts.

There is no interaction or control of the deployment process other than the intance start-up script (meta-data), which installs and starts gcs-pd.
If a base image would be used here, gcs-pd can be bundled as part of it, thus removing the need for a meta-data start-up script.

The use of GCS is mainly for simplicity of implementation, but in a more serious point-of-view, it is also a viable option given that it provides features as versioning, logging, ACLs and notifications, which are useful for implementing auditing and extra controls for validation and/or verification.

## Concept

The idea is simple and straightforward:
    - A start-up script is hosted in the instance (usually installed as part of the base image)
    - A group of static parameters is passed to the instance via meta-data, which are used for deployment:
    - A deployment info file and an artefact are stored in GCS
    - The deployment script does:
        - Pull the deployment info file and parse it
        - Download the artefact (info from previous step)
        - Unpack the artefact and execute the provided install.sh script
        - Start application

### Meta-data static parameters
|Key|Info|
|:-:|:--:|
|project_name|not yet in use|
|service_name|used by gcs-pd, must match the systemd unit name of the application to install|
|environment|not yet in use|
|config_url|not yet in use, reserved for application configuration|
|deploy_info|the location (gs://<bucket>/<key>) of the file containing the ARTEFACT_URL=<URL> for the application to install|

## Testing

Some of the requirements for testing might change in the future for usage of containers, but for the time being these need to be provided.

The test consist of:
    - Building a deployment package for gcs-pd
    - Building a deployment package for go-hello (the test app)
    - Deploying a set of infrastructure (VPC, GCS Bucket and files, instance)
    - Make an http call to go-hello, which should be deployed to the instance by gcs-pd

### Requirements
    - Docker (used for building the test app)
    - Terraform (for the test infra)
    - Make (unless you want to run the tests manually)
    - cURL (for testing)
    - A Google Cloud Platform (GCP) account
    - A GCP account key (json)
    - A GCP project
    - Google Cloud SDK (the gcloud cli tool)

### Execution
The sample below uses variables for passing credentials and project to terraform.
If you prefer to enter these manually, simply execute 'make test'.

```
    #  export TF_VAR_google_credentials="$(cat <PATH_TO_GCP_ACCOUNT_JSON_KEY>)"
    #  export TF_VAR_google_project=<GCP_PROJECT_ID>
    #  make test
```
