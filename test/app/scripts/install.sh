#!/bin/sh

INSTALL_DIR=/opt/go-hello


[ ! -d ${INSTALL_DIR} ] || rm -rf ${INSTALL_DIR}
mkdir ${INSTALL_DIR}
chown root:root /opt/go-hello
chmod 750 /opt/go-hello

install -m 750 -o root -g root -t /opt/go-hello hello
install -m 644 -o root -g root -D -t /usr/local/lib/systemd/system go-hello.service

systemctl daemon-reload
systemctl enable go-hello
systemctl restart go-hello
