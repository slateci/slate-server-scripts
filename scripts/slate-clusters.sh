#!/bin/bash

cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"

CHECKMK_TAG=${DEPLOYMENT_ENVIRONMENT:0:4}

export CHECKMK_TAG

./export_kconfigs.sh
lib/slate-clusters.sh > slate-clusters.out

aws s3 mv slate-clusters.out $AWS_CHECKMK_BUCKET
