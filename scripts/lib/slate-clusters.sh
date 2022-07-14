#!/bin/bash
cd "$( dirname "$(readlink -f "${BASH_SOURCE[0]}" )" )"
./for-all.sh ../configs ./slate-cluster-availability-check.sh
./for-all.sh ../configs ./slate-cluster-certificate-check.sh
