#!/bin/bash

clusters=$(curl -s https://${SLATE_API_ENDPOINT}:${SLATE_API_PORT}/v1alpha3/clusters?token=${SLATE_API_TOKEN} \
| sed -e 's|{|{\
|g' -e 's|,|,\
|g' | sed -n 's|"id":"\([^"]*\)".*|\1|p')

REQUEST="{"
for cluster in $clusters; do
	REQUEST="${REQUEST}"'"/v1alpha3/clusters/'"${cluster}/ping?token=${SLATE_API_TOKEN}"'":{"method":"GET"},'
done
REQUEST=$(echo "$REQUEST" | sed 's|,$|}|')
curl -s -d "$REQUEST" https://${SLATE_API_ENDPOINT}:${SLATE_API_PORT}/v1alpha3/multiplex?token=${SLATE_API_TOKEN} > /dev/null
