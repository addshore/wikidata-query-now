#!/bin/sh
gcloud compute instances create query-download-1 \
--machine-type=n2-standard-2 \
--scopes cloud-platform --scopes compute-rw \
--metadata-from-file=startup-script=startup.sh