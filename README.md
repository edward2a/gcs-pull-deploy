# GCS Pull Deploy

This is a sample implementation of the PULL deployment model in GCP, using GCS as a repository for deployment configuration and artefacts.

The use of GCS is mainly for simplicity of implementation, but in a more serious point-of-view, it is also a viable option given that it provides features as versioning, logging, ACLs and notifications, which are useful for implementing auditing and extra controls for validation and/or verification.

## Concept

The idea is simple and straightforward:
    - A startup script is hosted in the instance (usually installed as part of the base image)
    - A group of static parameters is passed to the instance via meta-data, which are used for deployment
    - A deployment info file and an artefact are stored in GCS
    - The deployment script does:
        - Pull the deployment info file and parse it
        - Download the artefact (info from previous step)
        - Unpack the artefact and execute the provided install.sh script
        - Start application
