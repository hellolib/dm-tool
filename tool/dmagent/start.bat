@echo off
setlocal
set "PRGDIR=%~dp0"
cd /d "%PRGDIR%"

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

set "allparam="

:param
set str=%1
if "%str%"=="" (
	goto intercept_left
)
set allparam=%allparam% %str%
shift /0
goto param

:intercept_left
if "%allparam:~0,1%"==" " (
	set "allparam=%allparam:~1%"
	goto intercept_left
)

:intercept_right
if "%allparam:~-1%"==" " (
	set "allparam=%allparam:~0,-1%"
	goto intercept_right
)

set "AGENT_HOME=%cd%"
set "AGENT_LIB=%AGENT_HOME%\lib"
rem set "CONFIG_FILE=%AGENT_HOME%\agent.ini"
set "CLIENT_CLASS=com.dameng.agent.Agent"

set "JAVA_MEM_OPTS=-Xms64m -Xmx2048m"
"%JAVA_EXE_FULL_PATH%" -cp "%AGENT_LIB%\*" com.dameng.common.util.ToolKitUtil getSystemProperty sun.arch.data.model | findstr "32" > nul 2>&1
if "%ERRORLEVEL%" == "0" (
	set "JAVA_MEM_OPTS="
)

"%JAVA_EXE_FULL_PATH%" %JAVA_MEM_OPTS% -cp "%AGENT_LIB%\*;%AGENT_LIB%\ext\*" -Ddameng.log.file="%AGENT_HOME%\log4j.xml" -Dagent.home="%AGENT_HOME%" %CLIENT_CLASS% %allparam%

goto :eof


