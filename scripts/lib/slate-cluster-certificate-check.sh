#!/bin/bash

# Help message
if [ "$#" -ne 2 ]; then
    echo "Checks whether the certificate of a cluster is about to expire"
    echo
    echo "      $0 KUBECONF CLUSTERNAME"
    echo
    echo "Example:  $0 ~/.kube/conf mycluster"
    exit -1
fi


kubectlconfig=$1
clustername=$2

IP=$(cat $kubectlconfig 2>/dev/null | grep server | awk '{print $2}' | cut -d'/' -f3)
ENDDATE=$(timeout 5 openssl s_client -showcerts -connect "$IP" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d'=' -f2)
if [ -n "$ENDDATE" ]; then
  if [ $(date -d "$ENDDATE" +%s) -gt $(date -d "now + 60 days" +%s) ]; then
    echo 0 SLATE-$CHECKMK_TAG-cluster-$clustername-certificate - Certificate is valid and willl expire in more than 60 days: $IP \($ENDDATE\)
  else
    if [ $(date -d "$ENDDATE" +%s) -gt $(date -d "now + 15 days" +%s) ]; then
      echo 1 SLATE-$CHECKMK_TAG-cluster-$clustername-certificate - Certificate is valid and willl expire in less than 60 days: $IP \($ENDDATE\)
    else
      echo 2 SLATE-$CHECKMK_TAG-cluster-$clustername-certificate - Certificate is invalid or needs to be renewed: $IP \($ENDDATE\)
    fi
  fi
else
  echo 1 SLATE-$CHECKMK_TAG-cluster-$clustername-certificate - Endpoint/certificate was not found: IP \($ENDDATE\)
fi

