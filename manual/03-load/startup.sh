#!/bin/sh

# Setup the RAID that will be used
apt-get update
apt-get install mdadm --no-install-recommends
mdadm --create /dev/md0 --level=0 --raid-devices=5 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3 /dev/nvme0n4 /dev/nvme0n5
mkfs.ext4 -F /dev/md0
mkdir -p /mnt/ssd
mount /dev/md0 /mnt/ssd
chmod a+w /mnt/ssd

# Install Docker
# https://docs.docker.com/engine/install/debian/
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Download the TTL files to local disks
# TODO make this configurable?
mkdir /mnt/ssd/ttl
gsutil -m cp -r gs://wikidata-collab/wdqs/20200827/0.3.45/munged/parquet /mnt/ssd

# Run Blazegraph
# TODO configurable version
docker pull wikibase/wdqs:0.3.40
docker run --rm --name qs-1 --entrypoint=/runBlazegraph.sh -d \
-v /mnt/ssd/dockerData:/wdqs/data \
-v /mnt/ssd:/mnt/ssd \
-e HEAP_SIZE="64g" \
-p 9999:9999 wikibase/wdqs:0.3.40

# Load the data
docker exec qs-1 /wdqs/loadData.sh -n wdq -d /mnt/ssd/ttl

# TODO stop Blazegraph

# TODO send the JNL file to a bucket

# Delete this instance
export NAME=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
export ZONE=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
gcloud --quiet compute instances delete $NAME --zone=$ZONE