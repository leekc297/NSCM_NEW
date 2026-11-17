@echo off
setlocal
for %%I in ("%~dp0..\..") do set "ROOT=%%~fI"
set "IIS=%ProgramFiles%\IIS Express\iisexpress.exe"
set "CFG=%ROOT%\GSCM\_asis_local\applicationhost.config"
if not exist "%IIS%" ( echo [FAIL] IIS Express not found: %IIS% & exit /b 2 )
if not exist "%CFG%" ( echo [FAIL] config not found: %CFG% & exit /b 3 )
echo AS-IS IIS Express start - %CFG% - site AsisLocal - http://localhost:8086
"%IIS%" /config:"%CFG%" /site:AsisLocal /systray:false
exit /b %ERRORLEVEL%
