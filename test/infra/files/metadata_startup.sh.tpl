#!/bin/sh
set -e

TMP_DIR=/var/tmp/gcs_pd
BUCKET=${bucket}
OBJECT=${object}
OBJECT_NAME=$${OBJECT##*/}

[ ! -d /var/tmp/gcs_pd ] ||

mkdir -p $${TMP_DIR}
cd $${TMP_DIR}

gsutil cp gs://$${BUCKET}/$${OBJECT} ./
tar -xf $${OBJECT_NAME}
bash install.sh
ret=$$?
if [ $${ret} -eq 0 ]; then
    echo "gcp-pd-install:success" > $${TMP_DIR}/result.log
else
    echo "gcp-pd-install:fail" > $${TMP_DIR}/result.log
fi

gsutil cp $${TMP_DIR}/result.log $${BUCKET}/result.log
exit $${ret}
