@echo off
chcp 65001 >nul
REM PKG 이식 일괄: 골격 생성 -> Claude Code 이식(최대 3회, check-pkg 게이트) -> Oracle 컴파일(run_sql.py, USER_ERRORS) -> 등록 SQL 실행(ROLLBACK 미리보기)
REM 사용: harness_pkg.cmd DMF0052
cd /d C:\Projects\NSCM
set ID=%1
if "%ID%"=="" ( echo 화면ID 필요 & exit /b 2 )
echo [%date% %time%] pkg %ID% >> Doc\gen\harness-log.txt
node tools\Harness\gen-register-sql.js %ID% >> Doc\gen\harness-log.txt 2>&1
node tools\Harness\repair-loop.js %ID% --pkg --max 3 >> Doc\gen\harness-log.txt 2>&1
python tools\DbConn\run_sql.py Doc\gen\%ID%\%ID%_PKG.sql --commit
if errorlevel 1 ( echo [FAIL] 패키지 컴파일 오류 - Doc\gen\%ID%\REPAIR_PKG.md 확인 & exit /b 1 )
python tools\DbConn\run_sql.py Doc\gen\%ID%\%ID%_registration.sql
echo 등록 SQL 은 ROLLBACK 미리보기입니다. BLOCK 8 결과가 맞으면:  python tools\DbConn\run_sql.py Doc\gen\%ID%\%ID%_registration.sql --commit
