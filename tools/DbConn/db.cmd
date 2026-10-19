@echo off
chcp 65001 >nul
REM DbConn 일괄: 드라이버 설치확인 -> 접속 점검 -> To-Be 메타 export -> 골든 케이스 생성 [-> 골든 실행]
REM 사용: db.cmd            (probe + export + gen cases)
REM       db.cmd golden     (위 + golden 실행, GET 류만)
setlocal
cd /d %~dp0
set LOG=C:\Projects\NSCM\Doc\db\_run.log
if not exist C:\Projects\NSCM\Doc\db mkdir C:\Projects\NSCM\Doc\db
echo ==== %date% %time% db.cmd %1 >> %LOG%
python -c "import oracledb" 2>nul || pip install --quiet oracledb >> %LOG% 2>&1
python -c "import pyodbc" 2>nul || pip install --quiet pyodbc >> %LOG% 2>&1
python probe.py >> %LOG% 2>&1
if errorlevel 1 echo [WARN] DB 접속 실패 있음 - Doc\db\probe_*.md 확인
python export_tobe_meta.py >> %LOG% 2>&1
python gen_golden_cases.py >> %LOG% 2>&1
if /i "%1"=="golden" python golden.py >> %LOG% 2>&1
echo 완료. 로그: %LOG%
type %LOG% | findstr /c:"[OK]" /c:"[FAIL]" /c:"행" /c:"요약" /c:"골든 케이스"
endlocal
