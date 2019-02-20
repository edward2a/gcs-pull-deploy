#!/bin/sh

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_DIR=${SCRIPT_PATH%/*}
BASE_DIR=${SCRIPT_DIR}/..

cp ${BASE_DIR}/scripts/go-hello.service ${BASE_DIR}/output/
cp ${BASE_DIR}/scripts/install.sh ${BASE_DIR}/output/install.sh

tar -C ${BASE_DIR}/output --exclude="pkg/*" -czvf go-hello.tar.gz .
[ -d ${BASE_DIR}/output/pkg ] || mkdir -p ${BASE_DIR}/output/pkg
mv go-hello.tar.gz ${BASE_DIR}/output/pkg/
echo "PACKAGE: $(find output/pkg -maxdepth 1 -name go-hello.tar.gz -printf '%p %k KiB \n')"
