#!/bin/sh

PRG="$0"
PRGDIR=`dirname "$PRG"`

cd "$PRGDIR/.."
DM_HOME=`pwd`
cd "$DM_HOME/bin"

VERSION_FLAG="client_version"
if [ "x$1" != "x" ]
then
	VERSION_FLAG="$1"
fi

"$DM_HOME/jdk/bin/java" -cp "$DM_HOME/tool/dropins/com.dameng/plugins/*" com.dameng.tool.util.VersionUtil $VERSION_FLAG