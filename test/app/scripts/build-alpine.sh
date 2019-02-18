#!/bin/sh

apk update
apk add make gcc musl-dev
make build-static
[ -z "${CALLER_UID}" ] || chown ${CALLER_UID} output/hello
