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
REM 2026-11-06 keep own path before any shift (shift also moves %0)
set "SELF=%~f0"
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
REM (0) 2026-11-06 per screen folders: parse the screen IDs BEFORE lock/log so a single screen run writes only to
REM     Doc\e2e\results\<ID>\ (results.json, html, artifacts, shots, _summary.csv/md) and Doc\e2e\logs\<ID>\ (run logs, _run.log)
REM     -> several screens run at the same time without overwriting each other (11-06 SCP0084/0037/0016 shared results.json clobber).
REM     Several IDs or no ID = one per-screen run per ID (see 0b). Shared folders/lock only when the caller sets E2E_RESULTS.
REM     A caller may pass its own E2E_RESULTS (respected as is).
set "ARGS=%*"
shift
set IDS=
set MODE=
set IDCNT=0
set ONEID=
:loop
if /i "%~1"=="--mode" ( set MODE=%~2 & shift & shift & goto loop )
if not "%~1"=="" ( set IDS=%IDS% %~1 & set "ONEID=%~1" & set /a IDCNT+=1 & shift & goto loop )
REM (0b) 2026-11-06 one lock style only (user): several IDs or no ID (all screens) no longer use the shared folder/lock.
REM      Each screen runs as its own single-screen run (per-screen lock _run.e2e.<ID>.lock + per-screen folders),
REM      one after another. Exit code = the largest child exit code. A caller-defined E2E_RESULTS keeps the old shared mode.
if defined E2E_RESULTS goto multi_done
if "%IDCNT%"=="1" goto multi_done
set "SUBMODE="
if not "%MODE%"=="" set "SUBMODE=--mode %MODE%"
set MULTIRC=0
if not "%IDCNT%"=="0" goto multi_ids
REM no ID = every screen that has a generated spec (Doc\e2e\specs\<ID>.plan.json)
for %%F in ("%E2EDIR%\specs\*.plan.json") do for /f "tokens=1 delims=." %%A in ("%%~nxF") do call :perscreen %%A
echo [INFO] run-e2e %KIND% all screens - per-screen runs done, max exit %MULTIRC%
exit /b %MULTIRC%
:multi_ids
for %%I in (%IDS%) do call :perscreen %%I
echo [INFO] run-e2e %KIND% %IDCNT% screens - per-screen runs done, max exit %MULTIRC%
exit /b %MULTIRC%
:perscreen
echo [INFO] run-e2e %KIND% %1 (per-screen)
cmd /c ""%SELF%" %KIND% %1 %SUBMODE%"
if %ERRORLEVEL% GTR %MULTIRC% set MULTIRC=%ERRORLEVEL%
exit /b 0
:multi_done
set "RDIR=%E2EDIR%\results"
set "LDIR=%E2EDIR%\logs"
set E2E_ID=
if not "%IDCNT%"=="1" goto dirs_set
set "RDIR=%E2EDIR%\results\%ONEID%"
set "LDIR=%E2EDIR%\logs\%ONEID%"
set "INDEX=%E2EDIR%\logs\%ONEID%\_run.log"
set "E2E_ID=%ONEID%"
:dirs_set
if not defined E2E_RESULTS set "E2E_RESULTS=%RDIR%"
if not exist "%E2E_RESULTS%" mkdir "%E2E_RESULTS%"
if not exist "%LDIR%" mkdir "%LDIR%"
REM (1) run lock + run id (single screen = Doc\e2e\_run.e2e.<ID>.lock / otherwise shared _run.lock - see runlock.js)
set RUNID=
for /f "usebackq tokens=*" %%i in (`node runlock.js acquire %ARGS%`) do set RUNID=%%i
if not "%RUNID%"=="" goto lock_ok
echo [FAIL] E2E not started - see the [FAIL] reason above (another run in progress)
exit /b 4
:lock_ok
REM (1b) 2026-11-12 T253: make sure the DB long-running-session watcher is up (warn 5 min, kill 30 min, own PC+OS user only). Failure does not stop the run.
python "%~dp0..\Harness\verify\db_orphan_sessions.py" --ensure-watch
set "LOG=%LDIR%\run_%RUNID%_%KIND%.log"
echo ==== %date% %time% run-e2e %ARGS% RUNID %RUNID% LOG %LOG% RESULTS %E2E_RESULTS% >> "%INDEX%"
echo ==== %date% %time% run-e2e %ARGS% > "%LOG%"
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
node runlock.js release %ARGS%
endlocal & exit /b 5
:svr_ok
echo FE 5173 / BE 8080 responding
if not exist accounts.json python gen-accounts.py >> %LOG% 2>&1
REM test mode (2026-10-27): --mode single (default: 1 account ADMIN or PLANNER) | admin (area ADMIN + no-auth user) | division (per role x Division accounts, CASCADE then CRUD - only screens the user designates) | auto (users.json screens -> else single)
set MODEARG=
if not "%MODE%"=="" set MODEARG=--mode %MODE%
node probe-accounts.js >> %LOG% 2>&1 || echo [WARN] no account can log in (BE down or users not registered) - specs use defaultAccount
REM refresh auth meta (3 tables, a few seconds) - corporate auth changes often (2026-10-20). On failure (VPN) keep existing CSV
python ..\DbConn\export_tobe_meta.py btn_auth user_group_user user_group_menu >> %LOG% 2>&1 || echo [WARN] auth meta refresh failed - using existing Doc\tobefacts\db CSV
if "%IDS%"=="" ( node gen-e2e.js --all %MODEARG% >> %LOG% 2>&1 ) else ( node gen-e2e.js %IDS% %MODEARG% >> %LOG% 2>&1 )
if not errorlevel 1 goto gen_ok
echo [FAIL] spec generation failed (gen-e2e.js) - log tail:
powershell -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 12"
node runlock.js release %ARGS%
endlocal & exit /b 6
:gen_ok
set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
REM 2026-10-22: "all" = smoke, crud, auth in order, then authcrud only when crud passed (crud failed -> authcrud SKIP)
if /i "%KIND%"=="all" goto run_all
REM @auth also matches @authcrud, so for auth only use a lookahead
set GREP=@%KIND%
if /i "%KIND%"=="auth" set GREP=@auth(?!crud)
REM with screen IDs only those spec files run (file-name filter, 2026-10-20)
echo Playwright %KIND%%IDS% running - output goes to the log file
node node_modules\@playwright\test\cli.js test %IDS% --grep "%GREP%" >> %LOG% 2>&1
set RC=%ERRORLEVEL%
goto after_pw
:run_all
set RC=0
set CRUD_RC=
call :one smoke
call :one crud
call :one auth
if "%CRUD_RC%"=="0" goto all_authcrud
echo [SKIP] authcrud - crud failed with exit %CRUD_RC%, authcrud not executed
echo [SKIP] authcrud - crud failed with exit %CRUD_RC% >> %LOG%
goto all_done
:all_authcrud
call :one authcrud
:all_done
echo log: %LOG%
node runlock.js release %ARGS%
endlocal & exit /b %RC%
:one
set K=%1
set G=@%K%
if /i "%K%"=="auth" set G=@auth(?!crud)
echo Playwright %K%%IDS% running - output goes to the log file
echo ---- %K% >> %LOG%
node node_modules\@playwright\test\cli.js test %IDS% --grep "%G%" >> %LOG% 2>&1
set KRC=%ERRORLEVEL%
node report.js
if errorlevel 1 if "%KRC%"=="0" set KRC=3
if /i "%K%"=="crud" set CRUD_RC=%KRC%
if not "%KRC%"=="0" echo [FAIL] %K% exit %KRC%
if not "%KRC%"=="0" if "%RC%"=="0" set RC=%KRC%
exit /b 0
:after_pw
REM 2026-10-21: propagate exit code (before, the last command's 0 was returned even when Playwright could not start - SCP0100)
if "%RC%"=="0" goto pw_ok
echo [FAIL] Playwright exit code %RC% - log tail:
powershell -NoProfile -Command "Get-Content -LiteralPath '%LOG%' -Tail 12"
:pw_ok
REM (3) report - results.json must be newer than this run (lock time), otherwise exit 3 (Playwright did not run)
node report.js
if errorlevel 1 if "%RC%"=="0" set RC=3
echo log: %LOG%
node runlock.js release %ARGS%
endlocal & exit /b %RC%
