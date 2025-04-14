#!/bin/sh

PRG="$0"
PRGDIR=`dirname "$PRG"`

CURRENT_DIR=`pwd`
cd "$PRGDIR/.."
DM_HOME=`pwd`
cd "$CURRENT_DIR"
JAVA_HOME="$DM_HOME/jdk"
TOOL_HOME="$DM_HOME/tool"

LD_LIBRARY_PATH="$DM_HOME/bin:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH

DM_CLIENT_PLUGINS="$TOOL_HOME/dropins/com.dameng/plugins"
DM_CLIENT_PLUGINS_THIRD="$DM_CLIENT_PLUGINS/com.dameng.third"
DM_CLIENT_PLUGINS_JDBC="$DM_CLIENT_PLUGINS/com.dameng.jdbc.drivers"

DTS_CMD_CLASSPATH="${DM_CLIENT_PLUGINS}/*"
DTS_CMD_CLASSPATH="${DTS_CMD_CLASSPATH}:${DM_CLIENT_PLUGINS_THIRD}/*"
DTS_CMD_CLASSPATH="${DTS_CMD_CLASSPATH}:${TOOL_HOME}/plugins/*"

START_TIME=`date +%s.%N`
"$JAVA_HOME/bin/java" -DDM_HOME="${DM_HOME}" -DeclipseHome="${TOOL_HOME}" -Ddameng.dts.drivers.dir="${DM_CLIENT_PLUGINS_JDBC}" -Xverify:none -Xms1024m -Xmx1024m -DwriteExcelByXml=false -DreadExcelByXml=-1 -cp "${DTS_CMD_CLASSPATH}" -Djava.library.path="$DM_HOME/bin" -Djava.net.preferIPv4Stack=true -Ddameng.log.file="$TOOL_HOME/log4j.xml" com.dameng.dts.cmd.Command $*
RC=$?
END_TIME=`date +%s.%N`


USE_TIME=`echo $END_TIME - $START_TIME | bc`
USE_TIME_S=`echo $USE_TIME | cut -d . -f 1`
USE_TIME_MS=`echo $USE_TIME | cut -d . -f 2 | cut -c 1-3`
echo "Total time: $USE_TIME_S.$USE_TIME_MS seconds"

exit $RC
