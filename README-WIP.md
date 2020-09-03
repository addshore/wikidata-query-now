# Wikidata Query Service Now!

This repository will help you get started running your own 

## Using the generated resources (auto)

TBA

## Running manually

This is currently designed to work on GCE (Google Cloud).

Standard format for each directory:

- `run.sh` - complete the whole step and tidy up
- `create.sh` - create the resources needed to complete the step (and maybe start execution)
- `execute.sh` - execute the step on provisioned resources
- `delete.sh` - create the resources used to complete the step

### 1) Dump download (to test)

Creates a small VM that will automatically download the latest dump file and store it at the correct location in a bucket.

Time: ~45 mins
Cost: TBA

### 2) Munge (WIP)

Creates a dataproc cluster to munge a downloaded dump using spark and output batched TTL files.

Time: ~45 mins
Cost: TBA

### 3) Load (TBA)

Creates a single large VM to run blazegraph on and load the munged TTL files into, outputing a JNL file.

Time: ~45 mins
Cost: TBA