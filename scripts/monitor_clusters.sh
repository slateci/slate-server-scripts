#!/bin/bash

clusters=$(curl -s ${SLATE_API_ENDPOINT}:${SLATE_API_PORT}/v1alpha3/clusters?token=${SLATE_API_TOKEN} \
| sed -e 's|{|{\
|g' -e 's|,|,\
|g' | sed -n 's|"id":"\([^"]*\)".*|\1|p')

REQUEST="{"
for cluster in $clusters; do
	REQUEST="${REQUEST}"'"/v1alpha3/clusters/'"${cluster}/ping?token=${SLATE_API_TOKEN}"'":{"method":"GET"},'
done
REQUEST=$(echo "$REQUEST" | sed 's|,$|}|')
curl -s -d "$REQUEST" ${SLATE_API_ENDPOINT}:${SLATE_API_PORT}/v1alpha3/multiplex?token=${SLATE_API_TOKEN} > /dev/null

DATE=`date`
CHECKMK_TAG=${DEPLOYMENT_ENVIRONMENT:0:4}

echo "0 SLATE-$CHECKMK_TAG-monitorclusters - Monitor clusters script last ran on $DATE" > monitor_clusters.log
aws s3 cp monitor_clusters.log $AWS_CHECKMK_BUCKET
