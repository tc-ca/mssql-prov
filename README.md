# mssql-prov

A docker container that allows for easy provisioning and patching of Microsoft SQL Server instances.

## Usage

The [example/](example/) directory contains an example dockerfile demonstrating how to use this image.
Additionally, there is a [patchdemo.sh](example/patchdemo.sh) script that demonstrates how patches are applied.

## General use case:

1. Create provision scripts that set up your database (e.g., ERwin forward-engineer, writing by hand)
2. Time passes. A change to the DB schema becomes required
3. The provision scripts are updated to reflect the desired state of the database
4. A patch is created that will upgrade the db from its existing state to the desired state
5. DB container is rebuilt with the new patch included
6. Once the new container is started, the DB will apply any new patches

## How it works

When the container starts up, it's running a bash script in addition to the script running the MSSQL instance.\
This script is responsible for:

- Detecting first-run of the database (does the patch_history table exist yet)
- First-time setup of the database (create the patch_history table)
- Identification and execution of unapplied patches

The provision files for the database should result in the desired schema, so when doing a first-run, the script will pretend to execute all existing patches so that they aren't executed in the future (since the db will already be in the desired state).

## Why?

- I needed a quick way to easily manage my database when prototyping
- Allows for database schema and changes to that schema to be committed to source control
- Allows deployment of latest/specific versions of the database to be simple and reproducible

## Why not?

- Requires rebuilding the DB container to apply updates
- Hosting your database in a container gives way to data persistence concerns - The example uses docker volumes to persist the db
- It makes the database team (rightfully) mad when you run everything all on your own.
