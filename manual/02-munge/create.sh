#!/bin/sh
gcloud dataproc clusters create query-munge-1 \
--subnet default --enable-component-gateway --image-version 1.3-debian10 \
--master-machine-type n1-standard-4 --master-boot-disk-type pd-ssd --master-boot-disk-size 60 \
--worker-machine-type n1-standard-8 --worker-boot-disk-type pd-ssd --worker-boot-disk-size 60 --num-worker-local-ssds 1 --num-workers 8