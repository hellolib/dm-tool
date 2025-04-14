#!/bin/sh

PRG="$0"
PRGDIR=`dirname "$PRG"`

CURRENT_DIR=`pwd`
cd "$PRGDIR/.."
DM_HOME=`pwd`
cd "$CURRENT_DIR"
JAVA_HOME="$DM_HOME/jdk"
TOOL_HOME="$DM_HOME/tool"
TOOL_WORKSPACE="$TOOL_HOME/workspace"
INSTALL_LANGUAGE=zh_CN

LD_LIBRARY_PATH="$DM_HOME/bin:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

MALLOC_ARENA_MAX=4
export MALLOC_ARENA_MAX

"$JAVA_HOME/bin/java" -Xms256m -Xmx2048m -XX:+PerfDisableSharedMem -DDM_HOME="$DM_HOME" -Djava.library.path="$DM_HOME/bin" -Ddameng.log.file="$TOOL_HOME/log4j.xml" -Dnl="$INSTALL_LANGUAGE" -Dapp.name=dbca -cp "$TOOL_HOME/plugins/*":"$TOOL_HOME/dropins/com.dameng/plugins/*":"$TOOL_HOME/dropins/com.dameng/plugins/com.dameng.third/*" com.dameng.dbca.Startup 2>&1 | (grep -Ev "^$|-GObject-")