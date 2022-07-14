#!/bin/bash

BUCKET_NAME=$AWS_CHECKMK_BUCKET
LOCAL_TMP=./tmp

mkdir -p $LOCAL_TMP
aws s3 mv $BUCKET_NAME $LOCAL_TMP --recursive >> /dev/null

if [ ! -z "$(ls -A $LOCAL_TMP)" ]; then
  cat $LOCAL_TMP/*
fi


rm -r $LOCAL_TMP
