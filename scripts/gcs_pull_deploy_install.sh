
INSTALL_DIR=/opt/gcs_pd
VAR_DATA=/var/gcs_pd
INIT_SCRIPT_DIR=/usr/local/lib/systemd/system
CONFIG_FILE=${INSTALL_DIR}/config.shvar


install_gcs_pd() {
    mkdir -p ${INSTALL_DIR} ${VAR_DATA}
    chmod 750 ${INSTALL_DIR} ${VAR_DATA}
    [ -d "${INIT_SCRIPT_DIR}" ] || mkdir -p ${INIT_SCRIPT_DIR}
    install -o root -g root -m 750 -t ${INSTALL_DIR} gcs_pull_deploy.sh
    install -o root -g root -m 644 -t ${INIT_SCRIPT_DIR} gcs-pull-deploy.service
    systemctl daemon-reload
    systemctl enable gcs-pull-deploy
}

configure() {
    echo "VAR_DATA=${VAR_DATA}" >> ${CONFIG_FILE}
}

main() {
    install_gcs_pd
    configure
}

# Execute
main
