#!/bin/sh

slateApiToken=$(cat "$HOME/.slate/token")
source /etc/slate/slate.conf

echo TOKEN $awsSecretKey

CLUSTERS=$(curl -s https://api.slateci.io:18080/v1alpha3/clusters?token=$slateApiToken | jq '.items')
if [ "$?" -ne 0 ]; then
	echo "Fetching cluster data failed" 1>&2
	exit 1
fi
LOCATIONS=$(echo "$CLUSTERS" | jq '{"clusters":[.[] | .metadata | select(.location | length > 0) | {"name":.name,"organization":.owningOrganization,"location":.location[]} | {"name":.name,"organization":.organization,"location":{"latitude":.location.lat,"longitude":.location.lon}}]}')
echo "$LOCATIONS" > map_data

s3cmd --no-progress --host=s3.amazonaws.com --access_key=$awsAccessKey --secret_key=$awsSecretKey -P put map_data s3://slate-geoip/map_data > /dev/null
