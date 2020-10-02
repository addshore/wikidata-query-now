#!/bin/sh

# Firewall rules that will be used for this instance
gcloud compute firewall-rules create default-allow-http --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server
gcloud compute firewall-rules create default-allow-https --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443 --source-ranges=0.0.0.0/0 --target-tags=https-server

#gcloud compute firewall-rules create jmx-48080-in --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:48080 --source-ranges=0.0.0.0/0 --target-tags=jmx-server

# Actually create the instances

gcloud compute instances create query-load-1 \
--tags=http-server,https-server,jmx-server \
--machine-type=c2-standard-16 \
--scopes cloud-platform --scopes compute-rw --scopes storage-rw \
--image=debian-10-buster-v20200902 --image-project=debian-cloud \
--boot-disk-type=pd-ssd \
--local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME \
--local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME --local-ssd=interface=NVME
