#!/bin/bash
set -u

#### COMMON VARS ####
CONFIG_FILE="/opt/gcs-pd/config.shvar"
METADATA_BASE_URL="http://metadata.google.internal/computeMetadata/v1/instance/attributes"


#### COMMON FUNCS ####
info() {
    logger -t gcs-pd -s "INFO: ${1}"
}

die() {
    local ERR
    ERR=${2:-1}
    logger -t gcs-pd -s "ERROR: ${1}"
    exit ${ERR}
}

load_config() {
    source ${CONFIG_FILE} || die "Failed loading config file"
}

get_metadata() {
    if [ -z "${1}" ]; then
        die "Missing parameter - metadata key"
    else
        curl -fs -H 'Metadata-Flavor: Google' "${METADATA_BASE_URL}/${1}" || \
            die "Curl exit ${?}" ${?}
    fi
}

get_instance_params() {
    PROJECT_NAME="$(get_metadata project_name)" || die "Failed fetching project_name"
    SERVICE_NAME="$(get_metadata service_name)" || die "Failed fetching service_name"
    ENVIRONMENT="$(get_metadata environment)" || die "Failed fetching environment"
    DEPLOY_INFO="$(get_metadata deploy_info)" || die "Failed fetching deploy_info"
    CONFIG_URL="$(get_metadata config_url)" || die "Failed fetching config_url"
}

get_deployment_config() {
    gsutil cp ${DEPLOY_INFO} ${VAR_DATA}/ 2>>${VAR_DATA}/gsutil.log || die "Failed downloading deployment configuration"
    source ${VAR_DATA}/deploy
    ARTEFACT_NAME=${ARTEFACT_URL##*/}
}

get_artefact() {
    gsutil cp ${1} ${VAR_DATA}/ 2>>${VAR_DATA}/gsutil.log || die "Failed downloading deployment artefact"
}

unpack_artefact() {
    [[ ! -d ${VAR_DATA}/deploy_pkg ]] || rm -rf ${VAR_DATA}/deploy_pkg
    mkdir ${VAR_DATA}/deploy_pkg

    case ${ARTEFACT_NAME##*.} in
        zip)
            cd ${VAR_DATA}/deploy_pkg
            unzip ${VAR_DATA}/${ARTEFACT_NAME} || die "Failed unpacking artefact"
            ;;
        tgz|gz)
            tar -C ${VAR_DATA}/deploy_pkg -xf ${VAR_DATA}/${ARTEFACT_NAME} || die "Failed unpacking artefact"
            ;;
    esac
}

install_application(){
    cd ${VAR_DATA}/deploy_pkg
    bash install.sh || die "Failed installing application"
}

start_application(){
    systemctl daemon-reload
    systemctl start ${1} || die "Failed starting application"
}

main() {
    load_config
    get_instance_params
    get_deployment_config
    get_artefact ${ARTEFACT_URL}
    unpack_artefact
    install_application
    start_application ${SERVICE_NAME}
    info 'Finished!'
}

# Execute
main
