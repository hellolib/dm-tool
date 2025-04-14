@echo off
setlocal enabledelayedexpansion

set "PRGDIR=%~dp0"

cd /d "%PRGDIR%"
set "TYPE=dmagent"
set "SERVICE_NAME=DmAgentService"

set "TOOLS_HOME=%cd%"
set "TOOLS_LIB_DIR=%TOOLS_HOME%\lib"
set "LOG4J_FILE_PATH=%TOOLS_HOME%\log4j.xml"

set "JAVA_EXE_FULL_PATH="
if not "%JAVA_HOME%" == "" (
	if exist "%JAVA_HOME%\jre\bin\java.exe" (
		set "JAVA_EXE_FULL_PATH=%JAVA_HOME%\jre\bin\java.exe"
	)
)

if "%JAVA_EXE_FULL_PATH%" == "" (
	if not "%JRE_HOME%" == "" (
		set "JAVA_EXE_FULL_PATH=%JRE_HOME%\bin\java.exe"
	)
)

if "%JAVA_EXE_FULL_PATH%" == "" (
	java -version > nul 2>&1
	if "%ERRORLEVEL%" == "0" (
		set "JAVA_EXE_FULL_PATH=java"
	) else (
		echo please set JRE_HOME or JAVA_HOME environment variable, or add "java" to PATH environment variable.
		goto :eof
	)
) else (
	if not exist "%JAVA_EXE_FULL_PATH%" (
		echo "%JAVA_EXE_FULL_PATH% file is not exist!"
		goto :eof
	)
)

if "%1" == "start" goto :checkServiceName
if "%1" == "stop" goto :checkServiceName
if "%1" == "restart" goto :checkServiceName
if "%1" == "delete" goto :checkServiceName
if "%1" == "status" goto :checkServiceName
goto :run

:checkServiceName
if "%SERVICE_NAME%" == "" (
	if "%2" == "" (
		call :echo_help
		goto:eof
	)
	set "SERVICE_NAME=%2"
)

for /f %%j in ('sc query %SERVICE_NAME% ^| findstr STATE') do (set STATUS=%%j)
if "!STATUS!" == "" (
	echo service '%SERVICE_NAME%' is not install.
	goto :eof
)

:run
if "%1" == "start" (
	net start "%SERVICE_NAME%"
	goto :eof
	
) else if "%1" == "stop" (
	net stop "%SERVICE_NAME%"
	goto :eof
	
) else if "%1" == "restart" (
	net restart "%SERVICE_NAME%"
	goto :eof
	
) else if "%1" == "install" (
	set "STATUS="
	if not "%SERVICE_NAME%" == "" (
		for /f %%j in ('sc query %SERVICE_NAME% ^| findstr STATE') do (set STATUS=%%j)
		if not "!STATUS!" == "" (
			echo service '%SERVICE_NAME%' is installed.
			goto :eof
		)
	)

	"%JAVA_EXE_FULL_PATH%" -Ddameng.log.file="%LOG4J_FILE_PATH%" -Dservice.name="%SERVICE_NAME%" -Dtools.home="%TOOLS_HOME%" -Dtype="%TYPE%" -cp "%TOOLS_LIB_DIR%\*" com.dameng.common.osservice.tools.script.ServiceScriptUtil install
	goto :eof
	
) else if "%1" == "delete" (
	set "STATUS="
	for /f %%k in ('sc query %SERVICE_NAME% ^| findstr STATE ^| findstr STOPPED') do (set STATUS=%%k)
	if "!STATUS!" == "" (
		net stop "%SERVICE_NAME%"
		
		for /f %%k in ('sc query %SERVICE_NAME% ^| findstr STATE ^| findstr STOPPED') do (set STATUS=%%k)
		if "!STATUS!" == "" (
			echo failed to stop the service '%SERVICE_NAME%'.
			goto :eof
		)
	)
	
	"%JAVA_EXE_FULL_PATH%" -Ddameng.log.file="%LOG4J_FILE_PATH%" -Dservice.name="%SERVICE_NAME%" -Dtools.home="%TOOLS_HOME%" -Dtype="%TYPE%" -cp "%TOOLS_LIB_DIR%\*" com.dameng.common.osservice.tools.script.ServiceScriptUtil delete "%SERVICE_NAME%"	
	goto :eof
	
) else if "%1" == "status" (
	set "STATUS="
	for /f %%j in ('sc query %SERVICE_NAME% ^| findstr STATE ^| findstr RUNNING') do (set STATUS=%%j)
	if not "!STATUS!" == "" (
		echo service '%SERVICE_NAME%' is running.
		goto :eof
	)
	
	set "STATUS="
	for /f %%k in ('sc query %SERVICE_NAME% ^| findstr STATE ^| findstr STOPPED') do (set STATUS=%%k)
	if not "!STATUS!" == "" (
		echo service '%SERVICE_NAME%' is stopped.
		goto :eof
	)
	echo service '%SERVICE_NAME%' is unknown.
) else if "%1" == "help" (
	call :echo_help
) else (
	call :echo_help
)
goto :eof

:echo_help
"%JAVA_EXE_FULL_PATH%" -Ddameng.log.file="%LOG4J_FILE_PATH%" -Dservice.name="%SERVICE_NAME%" -Dtools.home="%TOOLS_HOME%" -Dtype="%TYPE%" -cp "%TOOLS_LIB_DIR%\*" com.dameng.common.osservice.tools.script.ServiceScriptUtil help
goto :eof

:end
goto :eof