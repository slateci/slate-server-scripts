#!/bin/sh

source /etc/slate/slate.conf

export AWS_ACCESS_KEY_ID=$awsAccessKey
export AWS_SECRET_ACCESS_KEY=$awsSecretKey


ENDPOINT="https://dynamodb.us-east-2.amazonaws.com"
REGION="us-east-2"
CONFIGDIR="configs"
CONFIGTMPDIR="configs-tmp"

rm -f kconfigs
mkdir -p $CONFIGTMPDIR
rm -f $CONFIGTMPDIR/* # remove stale files

aws --endpoint-url ${ENDPOINT} --region ${REGION} dynamodb scan --table-name SLATE_clusters --projection-expression '#name,config' --filter-expression 'attribute_not_exists(#voID)' --expression-attribute-names '{"#name":"name", "#voID": "voID"}' > kconfigs
if [ "$?" -ne 0 ]; then
	echo "Export from AWS failed" 1>&2
	exit 1
fi

echo '"/Count"' > count_ptr
N=$(jsonpointer count_ptr kconfigs 2>&1) #figure out how many records we have
if echo "$N" | grep -q 'Could not resolve pointer' ; then
	echo "Invalid JSON document structure" 1>&2
	exit 1	
elif [ "$N" -gt 0 ]; then
	max=$(expr $N - 1)
	for i in `seq 0 $max`; do
		echo '"/Items/'$i'/name/S"' > name_ptr
		name=$(jsonpointer name_ptr kconfigs | sed 's|^"\(.*\)"$|\1|')
		echo '"/Items/'$i'/config/S"' > config_ptr
		config=$(jsonpointer config_ptr kconfigs | sed 's|^"\(.*\)"$|\1|')
		echo "$config" | sed 's/\\n/\
/g' > "$CONFIGTMPDIR/$name"
	done
	rm -f name_ptr config_ptr
else
	echo "No clusters found"
fi

rm -rf $CONFIGDIR
mv $CONFIGTMPDIR $CONFIGDIR

# Bunt4 being deprecated as of 8/4/21
#rsync -avz $CONFIGDIR/ dynamodb@bunt4.chpc.utah.edu:/usr/lib/slate-service/etc/new_configs
