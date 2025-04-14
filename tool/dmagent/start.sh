#!/bin/sh
PRG="$0"
PRGDIR=`dirname "$PRG"`
DIST_OS=`uname`

if [ -f "/etc/profile" ]
then
	. /etc/profile
fi

case `echo "testing\c"`,`echo -n testing` in
    *c*,-n*) ECHO_N=   ECHO_C=     ;;
    *c*,*)   ECHO_N=-n ECHO_C=     ;;
    *)       ECHO_N=   ECHO_C='\c' ;;
esac

JAVA_EXE_FULL_PATH=""
if [ "x$JAVA_HOME" != "x" ]
then
	if [ -f "$JAVA_HOME/jre/bin/java" ] 
	then
		JAVA_EXE_FULL_PATH="$JAVA_HOME/jre/bin/java"
	fi
fi

if [ "x$JAVA_EXE_FULL_PATH" = "x" ]
then
	if [ "x$JRE_HOME" != "x" ]
	then
		JAVA_EXE_PART_PATH="bin/java"
		if [ "$DIST_OS" = "SunOS" -o "$DIST_OS" = "Solaris" ]
		then
			BITS_NUM=`isainfo -b`
			if [ "x$BITS_NUM" = "x64" ]
			then
				JAVA_EXE_PART_PATH="bin/sparcv9/java"
			fi
		fi
		JAVA_EXE_FULL_PATH="$JRE_HOME/$JAVA_EXE_PART_PATH"
	fi
fi

if [ "x$JAVA_EXE_FULL_PATH" = "x" ]
then
	java -version > /dev/null 2>&1
	RETURN_CODE=`echo $?`
	if [ "$RETURN_CODE" -ne 0 ]
	then
		echo "please set JRE_HOME or JAVA_HOME environment variable, or add \"java\" to PATH environment variable."
		exit 11
	else
		JAVA_EXE_FULL_PATH="java"
	fi
else
	if [ ! -f "$JAVA_EXE_FULL_PATH" ]
	then
		echo "$JAVA_EXE_FULL_PATH file is not exist!"
		exit 12
	fi

	if [ ! -x "$JAVA_EXE_FULL_PATH" ]
	then
		chmod +x "$JAVA_EXE_FULL_PATH"
	fi
fi

MALLOC_ARENA_MAX=4
export MALLOC_ARENA_MAX

if [ "x$UPGRADE_SCRIPT_PATH" != "x" ]
then
	"$UPGRADE_SCRIPT_PATH"
	exit $?
fi

cd "$PRGDIR"
AGENT_HOME=`pwd`
AGENT_LIB="${AGENT_HOME}/lib"
CLIENT_CLASS=com.dameng.agent.Agent

DAEMON_FLAG="false"
if [ "$1" = "-d" ]
then
	shift
	DAEMON_FLAG="true"
elif [ "$1" = "--list" -o "$1" = "-l" ]
then
	echo "dmagent process list:"
	echo ""
	ps -ef | grep java | grep "dameng.log.file" | grep "agent.home" | grep ${CLIENT_CLASS}
	echo ""
	exit  0
fi

OTHER_ARGS="$*"

JAVA_MEM_OPTS="-Xms64m -Xmx2048m"
JAVA_ARCH_MODEL=`"$JAVA_EXE_FULL_PATH" -cp "$AGENT_LIB/*" com.dameng.common.util.ToolKitUtil getSystemProperty sun.arch.data.model`
if [ "$JAVA_ARCH_MODEL" = "32" ] 
then
	JAVA_MEM_OPTS=""
fi

CMD_LINE="\"${JAVA_EXE_FULL_PATH}\" $JAVA_MEM_OPTS -cp \"${AGENT_LIB}/*:${AGENT_LIB}/ext/*\" -Dnoconsole=$DAEMON_FLAG -Ddameng.log.file=\"${AGENT_HOME}/log4j.xml\" -Dagent.home=\"${AGENT_HOME}\" -Dagent.pid.file=\"${MY_PID_FILE}\" ${CLIENT_CLASS} $OTHER_ARGS"

if [ "$DAEMON_FLAG" = "true" ]
then
	eval exec "nohup $CMD_LINE" > /dev/null 2>&1 &
	AGENT_PID="$!"
	
	i=0
	echo $ECHO_N "Starting dmagent$ECHO_C"
	while test $i -ne 5
	do
		kill -0 "$AGENT_PID" >/dev/null 2>&1
		RETURN_CODE=$?
		if [ $RETURN_CODE -eq 0 ]
		then
			echo $ECHO_N ".$ECHO_C"
			i=`expr $i + 1`
			sleep 1
		else
			echo ""
			echo "dmagent may fail to start."
			exit 13
		fi
	done
	echo ""
	echo "dmagent(pid: $AGENT_PID) started successfully."
else
	echo "tip: if using the deployment feature, it is recommended to start dmagent with the '-d' parameter."
	eval exec "$CMD_LINE"
fi

exit $?
