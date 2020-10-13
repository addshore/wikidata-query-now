#!/bin/sh

# Config for the script
BUCKET=wikidata-collab
DUMP_SOURCE=https://dumps.wikimedia.your.org

# Download the latest dump and save it to the correct place
LATEST=$(curl -s $DUMP_SOURCE/wikidatawiki/entities/ | grep latest-all.ttl.bz2 | sed 's|.*\(....\)-\(...\)-\(..\).*|\3-\2-\1|')
DATE=$(date --date=$LATEST +'%Y%m%d')
echo $LATEST
echo $DATE
curl $DUMP_SOURCE/wikidatawiki/entities/latest-all.ttl.bz2 | gsutil cp - gs://$BUCKET/dumps/$DATE/wikidata-$DATE-all-BETA.ttl.bz2

# Delete this instance
export NAME=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/name -H 'Metadata-Flavor: Google')
export ZONE=$(curl -X GET http://metadata.google.internal/computeMetadata/v1/instance/zone -H 'Metadata-Flavor: Google')
gcloud --quiet compute instances delete $NAME --zone=$ZONE
