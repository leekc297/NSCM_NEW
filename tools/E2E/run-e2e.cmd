@echo off
chcp 65001 >nul
REM E2E batch runner: deps check -> run lock -> FE/BE check -> accounts/specs -> Playwright -> report
REM Usage: run-e2e.cmd [smoke|crud|auth|authcrud|all] [SCREEN_ID ...] [--mode admin|division|auto]   (default smoke; no ID = all of Doc\gen)
REM Stages (2026-10-20): smoke / crud / auth / authcrud  (details: README.md)
REM Prereq: FE http://127.0.0.1:5173 and BE http://localhost:8080 (profile local). If either is down -> [FAIL] exit 5
REM         (Vibe_Manager 1.9.6 starts BE/FE automatically before running this script)
REM 2026-10-21 fixes: (1) run lock _run.lock -> another run alive = exit 4   (2) per-run log Doc\e2e\logs\run_<RUNID>_<kind>.log
REM         (the shared _run.log was held by a concurrent run so every >> redirect failed and nothing ran, yet exit 0)
REM         (3) report.js checks results.json is newer than this run -> otherwise exit 3   ("exit 0 is not proof of execution")
REM RULE: keep this file ASCII only. With chcp 65001 cmd.exe mis-seeks after goto/blocks when the file contains multibyte text
REM       (verified 2026-10-21: Korean REM/echo lines broke the script). Korean messages live in runlock.js / report.js / README.md.
setlocal
cd /d %~dp0
set KIND=%1
if "%KIND%"=="" set KIND=smoke
set E2EDIR=C:\Projects\NSCM\Doc\e2e
set INDEX=%E2EDIR%\_run.log
if not exist %E2EDIR%\results mkdir %E2EDIR%\results
if not exist %E2EDIR%\logs mkdir %E2EDIR%\logs
REM No auto install (no external npm/browser download on the Local PC). node_modules is copied from the VM.
if exist node_modules\@playwright\test\cli.js goto deps_ok
echo [FAIL] tools\E2E\node_modules missing - not installed automatically. Ask Claude to copy node_modules.
exit /b 2
:deps_ok
REM (1) run lock + run id
set RUNID=
for /f "usebackq tokens=*" %%i in (`node runlock.js acquire %*`) do set RUNID=%%i
if not "%RUNID%"=="" goto lock_ok
echo [FAIL] E2E not started - see the [FAIL] reason above (another run in progress)
exit /b 4
:lock_ok
set LOG=%E2EDIR%\logs\run_%RUNID%_%KIND%.log
echo ==== %date% %time% run-e2e %* RUNID %RUNID% LOG %LOG% >> %INDEX%
echo ==== %date% %time% run-e2e %* > %LOG%
echo RUNID %RUNID% - log %LOG%
REM (2) FE/BE must both be up (before: only [WARN], then Playwright failed everything)
REM (note: 'set' after 'if errorlevel' resets ERRORLEVEL, so capture the curl codes first)
curl -s -o nul http://127.0.0.1:5173/
set FE_RC=%ERRORLEVEL%
curl -s -o nul http://localhost:8080/user/login
set BE_RC=%ERRORLEVEL%
if not "%FE_RC%"=="0" echo [FAIL] FE down - no response from http://127.0.0.1:5173 (Vibe_Manager "FE Start" or vite.cmd in nscm-fe\apps\web)
if not "%BE_RC%"=="0" echo [FAIL] BE down - no response from http://localhost:8080 (Vibe_Manager "BE Start" or gradlew.bat bootRun in nscm-be)
if "%FE_RC%%BE_RC%"=="00" goto svr_ok
echo [FAIL] FE/BE down - E2E not executed >> %LOG%
node runlock.js release
endlocal & exit /b 5
:svr_ok
echo FE 5173 / BE 8080 responding
if not exist accounts.json python gen-accounts.py >> %LOG% 2>&1
shift
set IDS=
set MODE=
:loop
if /i "%~1"=="--mode" ( set MODE=%~2 & shift & shift & goto loop )
if not "%~1"=="" ( set IDS=%IDS% %~1 & shift & goto loop )
REM test mode (2026-10-20): --mode admin (area ADMIN + no-auth user, master screens) | division (per-Division role accounts) | auto (users.json screens -> else meta guess)
set MODEARG=
if not "%MODE%"=="" set MODEARG=--mode %MODE%
node probe-accounts.js >> %LOG% 2>&1 || echo [WARN] no account can log in (BE down or users not registered) - specs use defaultAccount
REM refresh auth meta (3 tables, a few seconds) - corporate auth changes often (2026-10-20). On failure (VPN) keep existing CSV
python ..\DbConn\export_tobe_meta.py btn_auth user_group_user user_group_menu >> %LOG% 2>&1 || echo [WARN] auth meta refresh failed - using existing Doc\tobefacts\db CSV
if "%IDS%"=="" ( node gen-e2e.js --all %MODEARG% >> %LOG% 2>&1 ) else ( node gen-e2e.js %IDS% %MODEARG% >> %LOG% 2>&1 )
if not errorlevel 1 goto gen_ok
echo [FAIL] spec generation failed (gen-e2e.js) - log tail:
powershell -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 12"
node runlock.js release
endlocal & exit /b 6
:gen_ok
set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
REM @auth also matches @authcrud, so for auth only use a lookahead
set GREP=@%KIND%
if /i "%KIND%"=="auth" set GREP=@auth(?!crud)
REM with screen IDs only those spec files run (file-name filter, 2026-10-20)
echo Playwright %KIND%%IDS% running - output goes to the log file
if /i "%KIND%"=="all" ( node node_modules\@playwright\test\cli.js test %IDS% >> %LOG% 2>&1 ) else ( node node_modules\@playwright\test\cli.js test %IDS% --grep "%GREP%" >> %LOG% 2>&1 )
set RC=%ERRORLEVEL%
REM 2026-10-21: propagate exit code (before, the last command's 0 was returned even when Playwright could not start - SCP0100)
if "%RC%"=="0" goto pw_ok
echo [FAIL] Playwright exit code %RC% - log tail:
powershell -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 12"
:pw_ok
REM (3) report - results.json must be newer than this run (lock time), otherwise exit 3 (Playwright did not run)
node report.js
if errorlevel 1 if "%RC%"=="0" set RC=3
echo log: %LOG%
node runlock.js release
endlocal & exit /b %RC%
