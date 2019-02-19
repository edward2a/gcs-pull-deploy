#!/bin/bash

BUCKET=${bucket}
IDX=0
WAIT_SECS=10
MAX_LOOP=12

while ! RESULT=$(gsutil cat gs://gcs-pd-test/config/deploy); do
    echo "INFO: Waiting for gcs-pd deployment result..."
    sleep $${WAIT_SECS}
    let IDX++

    if [[ $${IDX} > $${MAX_LOOP} ]]; then
        echo "ERROR: Timed out waiting for deployment result"
        exit 1
    fi

done

if [[ $${RESULT##:} == "success" ]]; then
    echo 'INFO: Installation of gcs-pd is successful!'
    exit :0
elif [[ $${RESULT##:} == "fail" ]]; then
    echo 'ERROR: Installation of gcs-pd is fail!'
    exit 1
fi
