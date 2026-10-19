@echo off
cd /d C:\Projects\NSCM\tools\AsisFacts
echo [%date% %time%] agent start %* > C:\Projects\NSCM\Doc\asisfacts\agent-log.txt
powershell -NoProfile -ExecutionPolicy Bypass -File agent.ps1 DMF0052 >> C:\Projects\NSCM\Doc\asisfacts\agent-log.txt 2>&1
echo [%date% %time%] agent exit %ERRORLEVEL% >> C:\Projects\NSCM\Doc\asisfacts\agent-log.txt
