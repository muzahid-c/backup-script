@ECHO OFF
REM Backup Taking Script
REM Date: 01 Feb'17

REM No custom error handling, if error occurs log file will be populated with default message which may help

REM For net use authentication is needed if admin/password protected share is used
SET user=username
SET pass=password

REM Creation of logfile date format
SET LOGFILE_DATE=%DATE:~7,2%-%DATE:~4,2%-%DATE:~10,4%

REM For adding 0 (zero) infront of AM time 
SET hour=%time:~0,2%
IF "%hour:~0,1%" == " " set hour=0%hour:~1,1%
SET min=%time:~3,2%
IF "%min:~0,1%" == " " set min=0%min:~1,1%
SET secs=%time:~6,2%
IF "%secs:~0,1%" == " " set secs=0%secs:~1,1%


SET LOGFILE_TIME=%hour%-%min%-%secs%
SET LOGFILE=Backup_log-%LOGFILE_DATE%-%LOGFILE_TIME%.log
SET LOG_LOCATION="Location_of_the_log_file"

REM Redirect nul to suppress output as echo off don't work on net use 
NET USE "\\server1\share_file" /user:%user% %pass% >nul
NET USE "\\server2\C$\file" /user:%user% %pass% >nul 


REM Set start time for each pc in logfile after maping all the desired location

ECHO ---------------------server1----------------------------- >> %LOG_LOCATION%%LOGFILE%
ECHO Backup start time:- %date%-%time% >> %LOG_LOCATION%%LOGFILE%

REM Add a new line in log file
ECHO. >> %LOG_LOCATION%%LOGFILE%

REM Copy only new/changed file and populate log
XCOPY "\\server1\share_file\*" "Backup_Location\server1\" /D /E /C /Y >> %LOG_LOCATION%%LOGFILE%

REM For calculating size of backup in backup destination folder 
REM Using powershell as windows batch has limitation for recursive size measurement
ECHO. >> %LOG_LOCATION%%LOGFILE%

ECHO Source Size (bytes) >> %LOG_LOCATION%%LOGFILE% 
powershell -Command "& {Get-ChildItem -Path \\server1\share_file -Recurse | Measure-Object -Sum Length | Select-Object -expand Sum}" >> %LOG_LOCATION%%LOGFILE%

ECHO. >> %LOG_LOCATION%%LOGFILE%


ECHO Destination Size (bytes) >> %LOG_LOCATION%%LOGFILE% 
powershell -Command "& {Get-ChildItem -Path Backup_Location\server1 -Recurse | Measure-Object -Sum Length | Select-Object -expand Sum}" >> %LOG_LOCATION%%LOGFILE%

REM Set finish time in logfile
ECHO. >> %LOG_LOCATION%%LOGFILE%
ECHO Backup end time:- %date%-%time% >> %LOG_LOCATION%%LOGFILE%
ECHO. >> %LOG_LOCATION%%LOGFILE%
ECHO. >> %LOG_LOCATION%%LOGFILE%

ECHO ---------------------server2----------------------------- >> %LOG_LOCATION%%LOGFILE%
ECHO Backup start time:- %date%-%time% >> %LOG_LOCATION%%LOGFILE%
REM Add a new line in log file
ECHO. >> %LOG_LOCATION%%LOGFILE%

REM Copy only new/changed file and populate log
XCOPY "\\server2\C$\file\*" "Backup_Location\server2\" /D /E /C /Y >> %LOG_LOCATION%%LOGFILE%

REM For calculating size of backup in backup destination folder 
REM Using powershell as windows batch has limitation for recursive size measurement
ECHO. >> %LOG_LOCATION%%LOGFILE%

ECHO Source Size (bytes) >> %LOG_LOCATION%%LOGFILE% 
powershell -Command "& {Get-ChildItem -Path \\server2\C$\file -Recurse | Measure-Object -Sum Length | Select-Object -expand Sum}" >> %LOG_LOCATION%%LOGFILE%

ECHO. >> %LOG_LOCATION%%LOGFILE%


ECHO Destination Size (bytes) >> %LOG_LOCATION%%LOGFILE% 
powershell -Command "& {Get-ChildItem -Path Backup_Location\server2 -Recurse | Measure-Object -Sum Length | Select-Object -expand Sum}" >> %LOG_LOCATION%%LOGFILE%

REM Set finish time in logfile
ECHO. >> %LOG_LOCATION%%LOGFILE%
ECHO Backup end time:- %date%-%time% >> %LOG_LOCATION%%LOGFILE%
ECHO. >> %LOG_LOCATION%%LOGFILE%
ECHO. >> %LOG_LOCATION%%LOGFILE%



REM Deleting all netork mapping to clear session. This is important as if scheduler is used it may not connect next time because of previous sessions.

ECHO ---------------------Closing----------------------------- >> %LOG_LOCATION%%LOGFILE%
ECHO Disconnecting all network session... >> %LOG_LOCATION%%LOGFILE%
NET USE * /DELETE /YES >nul
ECHO Done! >> %LOG_LOCATION%%LOGFILE%
