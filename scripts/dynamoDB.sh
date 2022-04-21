#!/bin/bash

source /slate/slate.conf

echo "Listing Tables" > dynamo_out.log
aws dynamodb list-tables --region us-east-2 >> dynamo_out.log

ONE_MONTH_AGO=$((`date +%s` - 1209600))

echo "Listing Backups Within Two Weeks" >> dynamo_out.log
for i in $(aws dynamodb list-backups --region us-east-2 --time-range-lower-bound $ONE_MONTH_AGO | grep BackupCreationDateTime  | awk '{print $2}'  | tr -d ',' ); do date -d @$i; done >> dynamo_out.log

echo "Creating New Backup" >> dynamo_out.log
aws dynamodb create-backup --table-name SLATE_clusters --backup-name SLATE_clusters-VolumeFeature  --region us-east-2 >> dynamo_out.log
RESULT=$?

for i in CONNECT_groups CONNECT_users SLATE_groups SLATE_instances SLATE_moncreds SLATE_secrets SLATE_users SLATE_volumes; do aws dynamodb create-backup --table-name $i --backup-name $i-VolumeFeature  --region us-east-2; done >> dynamo_out.log

echo "Listing All Backups Within Two Weeks" >> dynamo_out.log
for i in $(aws dynamodb list-backups --region us-east-2 --time-range-lower-bound $ONE_MONTH_AGO | grep BackupCreationDateTime  | awk '{print $2}'  | tr -d ',' ); do date -d @$i; done >> dynamo_out.log

LAST_DATE=`tail dynamo_out.log -n 1`
DATE_DIFF=$(( `date +%s` - `date --date="$LAST_DATE" +%s`))

if [ $DATE_DIFF -lt 302400 ]; then
    echo "0 SLATE-dynamoDB-backup - Backup successful ($LAST_DATE)" >> dynamo_out.log
else
    echo "2 SLATE-dynamoDB-backup - Backup failed ($LAST_DATE)" >> dynamo_out.log
fi

