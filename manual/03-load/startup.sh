#!/bin/sh

# Setup the RAIDs that will be used
apt-get update
apt-get install mdadm --no-install-recommends
mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/nvme0n1 /dev/nvme0n2 /dev/nvme0n3
mdadm --create /dev/md1 --level=0 --raid-devices=3 /dev/nvme0n4 /dev/nvme0n5 /dev/nvme0n6 /dev/nvme0n7
mkfs.ext4 -F /dev/md0
mkfs.ext4 -F /dev/md1
mkdir -p /mnt/ssdRead
mkdir -p /mnt/ssdWrite
mount /dev/md0 /mnt/ssdRead
mount /dev/md1 /mnt/ssdWrite
chmod a+w /mnt/ssdRead
chmod a+w /mnt/ssdWrite

# Install things you want for monitoring and stuff
apt-get update
apt-get install -y \
    htop \
    lsof \
    screen

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

# Download the TTL files to local disks (and rename)
apt-get update
apt-get install -y \
    rename
# TODO make this configurable?
gsutil -m cp -r gs://wikidata-collab/wdqs/20200827/0.3.47/munged/nt /mnt/ssdRead
rename -v 's/(part-\d+)(\.gz)/$1.ttl$2/' /mnt/ssdRead/nt/*

# Perhaps improve blazegraph performance
sysctl -w vm.swappiness=0

# Run Blazegraph
# TODO configurable version
docker pull wikibase/wdqs:0.3.40
docker run --name qs --entrypoint=/runBlazegraph.sh -d \
-v /mnt/ssdWrite:/wdqs/data \
-v /mnt/ssdRead:/mnt/ssdRead \
-v /var/log/wdqs:/var/log/wdqs \
-e HEAP_SIZE="22g" \
-p 9999:9999 \
-p 48080:48080 \
wikibase/wdqs:0.3.40

# Load the data
docker exec qs /wdqs/loadRestAPI.sh -n wdq -d /mnt/ssdRead/nt

# TODO stop Blazegraph

# TODO send the JNL file to a bucket

# Delete this instance
#export NAME=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
#export ZONE=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
#gcloud --quiet compute instances delete $NAME --zone=$ZONE