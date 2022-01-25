# Scripts and cron tab for the API server

This repository contains the scripts that run on the API server as cron jobs. These scripts are necessary for the correct functioning and monitoring of the API server.

## collect_map_data

This script collects the GPS locations of the sites and makes them avilable to the website from page map.

## dynamoDB

This script backs up the database. The output is used by checkmk script to alert if the backup was not executed.

## export_kconfigs

This script collects the kubernetes configurations, which are then used by various script, including the checkmk ones, to monitoring the status of the infrastructure.

## monitor_clusters

This scripts checks whether the clusters are available and updates the api service accordingly so that the portal can show which clusters are active or inactive.

## crontab

```
0 12 * * * cd /home/centos/kconf_extraction && ./export_kconfigs.sh
12,32,52 * * * * /home/centos/monitor_clusters.sh
0 0 * * * /home/centos/collect_map_data.sh
0 12 * * 1 /home/centos/dynamoDB.sh
0 12 * * 5 /home/centos/slate-checkmk/slate-clusters-cert-notification.sh &> /home/centos/slate-checkmk/out/slate-clusters-cert-notification.out
```
