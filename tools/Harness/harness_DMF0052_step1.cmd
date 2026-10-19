@echo off
cd /d C:\Projects\NSCM\tools\Harness
echo [%date% %time%] new-screen DMF0052 start > C:\Projects\NSCM\Doc\gen\harness-log.txt
powershell -NoProfile -ExecutionPolicy Bypass -File new-screen.ps1 DMF0052 >> C:\Projects\NSCM\Doc\gen\harness-log.txt 2>&1
echo [%date% %time%] exit %ERRORLEVEL% >> C:\Projects\NSCM\Doc\gen\harness-log.txt
