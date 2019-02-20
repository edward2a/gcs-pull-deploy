#!/bin/sh

apk update
apk add make gcc musl-dev
make build
[ -z "${CALLER_UID}" ] || chown ${CALLER_UID} output/go-hello
