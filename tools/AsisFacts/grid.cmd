@echo off
cd /d C:\Projects\NSCM\tools\AsisFacts
echo [%date% %time%] grid start > C:\Projects\NSCM\Doc\asisfacts\grid-log.txt
powershell -NoProfile -ExecutionPolicy Bypass -File grid.ps1 >> C:\Projects\NSCM\Doc\asisfacts\grid-log.txt 2>&1
echo [%date% %time%] grid exit %ERRORLEVEL% >> C:\Projects\NSCM\Doc\asisfacts\grid-log.txt
