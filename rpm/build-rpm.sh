#!/bin/bash
VERSION=`grep Version slate-server-scripts.spec | cut -f 2 -d: | tr -d [:space:]`
TAR_DIR="slate-server-scripts-$VERSION"
mkdir $TAR_DIR
cp ../*.sh $TAR_DIR
tar cvzf $TAR_DIR.tar.gz $TAR_DIR
cp $TAR_DIR.tar.gz $RPM_BUILD_ROOT/SOURCES
cp slate-server-scripts.spec $RPM_BUILD_ROOT/SRPMS
mock --buildsrpm --spec slate-server-scripts.spec --sources $TAR_DIR.tar.gz --resultdir=.
mock *.src.rpm  --resultdir=.
 
