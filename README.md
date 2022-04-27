# Scripts for the API server

This repository contains the scripts that run cron jobs in Kubernetes. These scripts are necessary for the correct functioning and monitoring of the API server.

## Descriptions

### collect_map_data

This script collects the GPS locations of the sites and makes them available to the website from page map.

### dynamoDB

This script backs up the database. The output is used by checkmk script to alert if the backup was not executed.

### export_kconfigs

This script collects the kubernetes configurations, which are then used by various script, including the checkmk ones, to monitoring the status of the infrastructure.

### monitor_clusters

This scripts checks whether the clusters are available and updates the api service accordingly so that the portal can show which clusters are active or inactive.

### test

This script exists for testing Kubernetes and the CronJob object.

## Local Development with Docker Compose

> **_IMPORTANT:_** this section requires familiarity with [Running the Server](https://github.com/slateci/slate-client-server/blob/master/resources/docs/server_running.md).

This local process is meant to mimic our Kubernetes cluster out on the Google Kubernetes Engine (GKE). There each script is instantiated as a Cron Job using the [cronjobs.yml](https://github.com/slateci/helm-slate-api/blob/develop/templates/cronjobs.yml) template.

This template has the following available to it:
* A copy of `resources/docker/conf/slate.conf` mounted to `${SLATE_API_CONF}`.
* The Docker environmental variables defined in `.env.tmpl` as full system-level environmental variables.

### Requirements

#### Install Docker/Compose

Install [Docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/) for developing, managing, and running OCI containers on your system.

#### Create `.env`

1. Copy `.env.tmpl` to the following place in this project: `.env`.
2. Modify the included environmental variables as desired.

### Build and Run API Scripts Environment

Bring up the local development environment via the following:

```shell
[your@localmachine]$ docker-compose up
Building slate_api_scripts
Sending build context to Docker daemon  22.02kB
Step 1/11 : ARG baseimage=centos:7
Step 2/11 : FROM ${baseimage} as local-stage
 ---> eeb6ee3f44bd
Step 3/11 : RUN yum install epel-release -y
...
...
Successfully tagged slate_api_scripts:local
Recreating slate_api_scripts ... done
Attaching to slate_api_scripts
slate_api_scripts    | Copying clean slate.conf...
```

### Test the API Scripts

While `docker-compose` is still running attach to the `slate_api_scripts` container and run a script(s) in `/slate/scripts`:

```shell
$ docker exec -it slate_api_scripts bash
[root@d614a7bf3483 slate]# cd /slate/scripts
[root@d614a7bf3483 scripts]# ./test.sh
...
...
```

### Teardown

In the terminal session running `docker-compose up` type `CTRL + C` to stop all existing containers. Finally, teardown using one of the following options:

* Leave the associated images, volumes, and networks on your machine by executing:

  ```shell
  [your@localmachine]$ docker-compose down
  ```

  **Result:** re-running `docker-compose up` will restart services with their existing states.

* Completely remove everything:

  ```shell
  [your@localmachine]$ docker-compose down --rmi all
  ```

  **Result:** re-running `docker-compose up` will start everything from scratch.
