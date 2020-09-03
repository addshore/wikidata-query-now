#!/bin/sh

# Firewall rules that will be used for this instance
gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

# Actually create the instance
gcloud compute instances create query-load-1 --machine-type=n1-standard-64 \
--scopes cloud-platform --scopes compute-rw \
--image=debian-10-buster-v20200805 --image-project=debian-cloud --tags=http-server,https-server --boot-disk-type=pd-ssd \
--local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME \
--metadata-from-file=startup-script=startup.sh
