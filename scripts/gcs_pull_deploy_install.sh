#!/bin/sh

INSTALL_DIR=/opt/gcs_pd
VAR_DATA=/var/gcs_pd
INIT_SCRIPT_DIR=/usr/local/lib/systemd/system
CONFIG_FILE=${INSTALL_DIR}/config.shvar


install() {
    mkdir -p ${INSTALL_DIR} ${VAR_DATA}
    chmod 750 ${INSTALL_DIR} ${VAR_DATA}
    install -u root -g root -m 750 -t ${INSTALL_DIR} gcs_pull_deploy.sh
    install -u root -g root -m 644 -t ${INIT_SCRIPT_DIR} gcs_pull_deploy.service
    systemctl daemon-reload
    systemctl enable gcs-pd
}

configure() {
    echo "VAR_DATA=${VAR_DATA}" >> ${CONFIG_FILE}
}
