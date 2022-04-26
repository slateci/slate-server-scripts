#!/bin/sh

source /slate/slate.conf

echo "SLATE API: https://SLATE_API_ENDPOINT:${SLATE_API_PORT}"

echo "Testing help for aws cli:"
aws help
