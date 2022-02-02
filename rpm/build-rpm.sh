#!/bin/bash
set -x
VERSION=`grep Version slate-server-scripts.spec | cut -f 2 -d: | tr -d [:space:]`
TAR_DIR="slate-server-scripts-$VERSION"
mkdir $TAR_DIR
cp ../*.sh $TAR_DIR
tar cvzf $TAR_DIR.tar.gz $TAR_DIR
rm -fr $TAR_DIR
EXTRA_OPTS=""
if [[ ! -z "$1" ]];
then
  EXTRA_OPTS="-r $1"
fi
mock $EXTRA_OPTS --buildsrpm --spec slate-server-scripts.spec --sources $TAR_DIR.tar.gz --resultdir=.
mock $EXTRA_OPTS *.src.rpm  --resultdir=. 
