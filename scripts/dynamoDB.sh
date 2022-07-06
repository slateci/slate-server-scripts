#!/bin/bash

source "${SLATE_API_CONF}"

CHECKMK_TAG=${DEPLOYMENT_ENVIRONMENT:0:4}
S3_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
S3_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
S3_AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION
AWS_ACCESS_KEY_ID=$DYNAMO_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$DYNAMO_AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=$DYNAMO_AWS_DEFAULT_REGION

echo "Listing Tables"
aws dynamodb list-tables

ONE_MONTH_AGO=$((`date +%s` - 1209600))

echo "Listing Backups Within Two Weeks"
for i in $(aws dynamodb list-backups --time-range-lower-bound $ONE_MONTH_AGO | grep BackupCreationDateTime  | awk '{print $2}'  | tr -d ',' ); do echo $i; done

echo "Creating New Backup"
aws dynamodb create-backup --table-name SLATE_clusters --backup-name SLATE_clusters-VolumeFeature
RESULT=$?

for i in CONNECT_groups CONNECT_users SLATE_groups SLATE_instances SLATE_moncreds SLATE_secrets SLATE_users SLATE_volumes; do aws dynamodb create-backup --table-name $i --backup-name $i-VolumeFeature; done

echo "Listing All Backups Within Two Weeks"
for i in $(aws dynamodb list-backups --time-range-lower-bound $ONE_MONTH_AGO | grep BackupCreationDateTime  | awk '{print $2}'  | tr -d ',' ); do echo $i; done

LAST_DATE=${i:1:-1}
DATE_DIFF=$(( `date +%s` - `date --date="$LAST_DATE" +%s`))

if [ $DATE_DIFF -lt 302400 ]; then
    echo "0 SLATE-$CHECKMK_TAG-dynamoDB-backup - Backup successful ($LAST_DATE)" > dynamoDB.out
else
    echo "2 SLATE-$CHECKMK_TAG-dynamoDB-backup - Backup failed ($LAST_DATE)" > dynamoDB.out
fi

AWS_ACCESS_KEY_ID=$S3_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$S3_AWS_SECRET_ACCESS_KEY
AWS_DEFAULT_REGION=$S3_AWS_DEFAULT_REGION

aws s3 mv dynamoDB.out $AWS_CHECKMK_BUCKET
