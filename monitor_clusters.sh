#!/bin/sh

TOKEN=$(cat "$HOME/.slate/token")

clusters=$(curl -s https://api.slateci.io:18080/v1alpha3/clusters?token=${TOKEN} \
| sed -e 's|{|{\
|g' -e 's|,|,\
|g' | sed -n 's|"id":"\([^"]*\)".*|\1|p')

REQUEST="{"
for cluster in $clusters; do
	REQUEST="${REQUEST}"'"/v1alpha3/clusters/'"${cluster}/ping?token=${TOKEN}"'":{"method":"GET"},'
done
REQUEST=$(echo "$REQUEST" | sed 's|,$|}|')
curl -s -d "$REQUEST" https://api.slateci.io:18080/v1alpha3/multiplex?token=${TOKEN} > /dev/null
