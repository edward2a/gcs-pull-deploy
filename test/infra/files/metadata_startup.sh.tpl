#!/bin/sh
set -e

TMP_DIR=/var/tmp/gcs_pd
BUCKET=${bucket}
OBJECT=${object}
OBJECT_NAME=$${OBJECT##*/}

[ ! -d $${TMP_DIR} ] || rm -rf $${TMP_DIR}

mkdir -p $${TMP_DIR}
cd $${TMP_DIR}

gsutil cp gs://$${BUCKET}/$${OBJECT} ./
tar -xf $${OBJECT_NAME}
bash install.sh
ret=$${?}
if [ $${ret} -eq 0 ]; then
    echo "gcp-pd-install:success" > $${TMP_DIR}/result.log
else
    echo "gcp-pd-install:fail" > $${TMP_DIR}/result.log
fi

# not necessary when gcs-pd is installed as part of the base image
systemctl start gcs-pull-deploy

gsutil cp $${TMP_DIR}/result.log gs://$${BUCKET}/result.log
exit $${ret}
