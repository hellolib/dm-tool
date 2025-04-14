#!/bin/sh
PRG="$0"
PRGDIR=`dirname "$PRG"`

cd "$PRGDIR"
TYPE="dmagent"
SERVICE_NAME="DmAgentService"

TOOLS_HOME=`pwd`
TOOLS_LIB_DIR="$TOOLS_HOME/lib"
LOG4J_FILE_PATH="$TOOLS_HOME/log4j.xml"

if [ "x$SERVICE_NAME" = "x" ]
then
	SERVICE_NAME="$2"
fi

#run by root
RUID=`/usr/bin/id|awk -F\( '{print $1}'|awk -F\= '{print $2}'`
if [ ${RUID} != "0" ]
then
	echo "must run the script by root!"
	exit 1
fi

if [ -f "/etc/profile" ]
then
	. /etc/profile
fi

JAVA_EXE_FULL_PATH=""
if [ "x$JAVA_HOME" != "x" ]
then
	if [ -d "$JAVA_HOME/jre" -a -f "$JAVA_HOME/jre/bin/java" ] 
	then
		JAVA_EXE_FULL_PATH="$JAVA_HOME/jre/bin/java"
	fi
fi

if [ "x$JAVA_EXE_FULL_PATH" = "x" ]
then
	if [ "x$JRE_HOME" != "x" ]
	then
		JAVA_EXE_PART_PATH="bin/java"
		#os name
		DIST_OS=`uname`
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
		exit 1
	else
		JAVA_EXE_FULL_PATH="java"
	fi
else
	if [ ! -f "$JAVA_EXE_FULL_PATH" ]
	then
		echo "$JAVA_EXE_FULL_PATH file is not exist!"
		exit 1
	fi

	if [ ! -x "$JAVA_EXE_FULL_PATH" ]
	then
		chmod +x "$JAVA_EXE_FULL_PATH"
	fi
fi

echo_help() {
	"$JAVA_EXE_FULL_PATH" -Ddameng.log.file="$LOG4J_FILE_PATH" -Dservice.name="$SERVICE_NAME" -Dtools.home="$TOOLS_HOME" -Dtype="$TYPE" -cp "$TOOLS_LIB_DIR/*" com.dameng.common.osservice.tools.script.ServiceScriptUtil help
}

if [ "$1" = "start" -o "$1" = "stop" -o "$1" = "status" -o "$1" = "restart" -o "$1" = "delete" ]
then
	if [ "x$SERVICE_NAME" = "x" ]
	then
		echo_help
		exit 2
	fi
fi

EXSIT_SERVICE="false"
if [ "$SERVICE_NAME" != "" ]
then
	"$JAVA_EXE_FULL_PATH" -Ddameng.log.file="$TOOLS_HOME/log4j.xml" -Dservice.name="$SERVICE_NAME" -Dtools.home="$TOOLS_HOME" -Dtype="$TYPE" -cp "$TOOLS_LIB_DIR/*" com.dameng.common.osservice.tools.script.ServiceScriptUtil exist "$SERVICE_NAME"
	RETURN_CODE=$?
	if [ "$RETURN_CODE" = "0" ]
	then
		EXSIT_SERVICE="true"
	elif [ "$RETURN_CODE" = "1" ]
	then
		EXSIT_SERVICE="false"
	else
		exit $RETURN_CODE
	fi
fi

if [ "$1" = "start" -o "$1" = "stop" -o "$1" = "status" -o "$1" = "restart" -o "$1" = "delete" ]
then
	if [ "$EXSIT_SERVICE" != "true" ]
	then
		echo "service $SERVICE_NAME is not install."
		exit 3
	fi
fi

case "$1" in
	start)
		service $SERVICE_NAME start 
		;;
	stop)
		service $SERVICE_NAME stop 
		;;
	status)
		service $SERVICE_NAME status 
		;;
	restart)
		service $SERVICE_NAME restart 
		;;
	install)
		if [ "$EXSIT_SERVICE" = "true" ]
		then
			echo "The service $SERVICE_NAME is installed."
			exit 4
		fi
		
		"$JAVA_EXE_FULL_PATH" -Ddameng.log.file="$TOOLS_HOME/log4j.xml" -Dservice.name="$SERVICE_NAME" -Dtools.home="$TOOLS_HOME" -Dtype="$TYPE" -cp "$TOOLS_LIB_DIR/*" com.dameng.common.osservice.tools.script.ServiceScriptUtil install
		;;
	delete)
		service $SERVICE_NAME stop
		RETURN_CODE=$?
		if [ $RETURN_CODE -ne 0 ]
		then
			echo "failed to stop the service($SERVICE_NAME)"
			exit 1
		fi
		
		"$JAVA_EXE_FULL_PATH" -Ddameng.log.file="$TOOLS_HOME/log4j.xml" -Dservice.name="$SERVICE_NAME" -Dtools.home="$TOOLS_HOME" -Dtype="$TYPE" -cp "$TOOLS_LIB_DIR/*" com.dameng.common.osservice.tools.script.ServiceScriptUtil delete "$SERVICE_NAME"
		;;
	help)
		echo_help
		;;
	*)
		echo_help
		exit 1
		;;
esac
