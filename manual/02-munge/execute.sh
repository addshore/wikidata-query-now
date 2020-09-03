#!/bin/sh
# TODO configurable rdf tools version? (once released..?)
# TODO configurable dump location & output?
gcloud dataproc jobs submit spark --cluster=query-munge-1 \
--class=org.wikidata.query.rdf.spark.WikidataTurtleDumpConverter \
--jars=gs://wikidata-collab/rdf-spark-tools-0.3.47-SNAPSHOT-jar-with-dependencies-ADDSHORE1.jar \
--properties=spark.master=yarn \
--properties=spark.executor.memory=25G \
--properties=spark.executor.cores=8 \
--properties=spark.driver.memory=2G \
--properties=spark.dynamicAllocation.enabled=true \
--properties=spark.dynamicAllocation.maxExecutors=64  \
--properties=fs.gs.block.size=536870912  \
-- \
--input-path gs://wikidata-collab/dumps/20200827/wikidata-20200827-all-BETA.ttl.bz2 \
--num-partitions 512 \
--output-path gs://wikidata-collab/wdqs/20200827/0.3.47/munged/ttl \
--output-format ttl \
--skolemize