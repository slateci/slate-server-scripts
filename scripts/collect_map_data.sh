#!/bin/bash

source "${SLATE_API_CONF}"

if [[ "$DEPLOYMENT_ENVIRONMENT" != "production" ]]; then
    echo Script will run only on production
    exit 0
fi


CLUSTERS=$(curl -s ${SLATE_API_ENDPOINT}:${SLATE_API_PORT}/v1alpha3/clusters?token=${SLATE_API_TOKEN} | jq '.items')
if [ "$?" -ne 0 ]; then
	echo "Fetching cluster data failed" 1>&2
	exit 1
fi

LOCATIONS=$(echo "$CLUSTERS" | jq '{"clusters":[.[] | .metadata | select(.location | length > 0) | {"name":.name,"organization":.owningOrganization,"location":.location[]} | {"name":.name,"organization":.organization,"location":{"latitude":.location.lat,"longitude":.location.lon}}]}')
echo "$LOCATIONS" > map_data

s3cmd --no-progress --host=s3.amazonaws.com --access_key=${AWS_ACCESS_KEY_ID} --secret_key=${AWS_SECRET_ACCESS_KEY} -P put map_data s3://slate-geoip/map_data > /dev/null

DATE=`date`
CHECKMK_TAG=${DEPLOYMENT_ENVIRONMENT:0:4}

echo "0 SLATE-$CHECKMK_TAG-collectmapdata - Map data collect script last ran on $DATE" > collect_map_data.log
aws s3 cp collect_map_data.log $AWS_CHECKMK_BUCKET
