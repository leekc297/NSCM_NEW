@echo off
chcp 65001 >nul
REM 트랙 B 일괄 (노트북 네이티브 실행 — VM 에서 연결 폴더 위로 돌리면 너무 느려서 여기서 돈다)
REM 순서: TobeFacts(스캔→교차검증→Pack→카탈로그) -> 대사표 -> GAP -> DMF0052 gen/등록SQL/PKG -> 파이프라인 드라이런 -> E2E 스펙 -> 스냅샷 기준선
REM 사용: batch_B.cmd            로그: Doc\_batch\B_<일시>.log  (Claude 가 읽는다)
setlocal
cd /d C:\Projects\NSCM
if not exist Doc\_batch mkdir Doc\_batch
set TS=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%
set TS=%TS: =0%
set LOG=Doc\_batch\B_%TS%.log
echo ==== batch_B %date% %time% > %LOG%

echo [B1] TobeFacts run.ps1 (스캔/교차검증/Pack/카탈로그)
echo ==== [B1] TobeFacts >> %LOG%
powershell -NoProfile -ExecutionPolicy Bypass -File tools\TobeFacts\run.ps1 >> %LOG% 2>&1
echo     exit %ERRORLEVEL% >> %LOG%

echo [B2] 대사표 (xlsx_to_csv -> recon)
echo ==== [B2] Recon >> %LOG%
python tools\Recon\xlsx_to_csv.py >> %LOG% 2>&1
node tools\Recon\recon.js >> %LOG% 2>&1
echo     exit %ERRORLEVEL% >> %LOG%

echo [B3] GAP 전 화면
echo ==== [B3] GAP >> %LOG%
node tools\Harness\gap.js >> %LOG% 2>&1
echo     exit %ERRORLEVEL% >> %LOG%
node tools\Harness\suggest-rules.js >> %LOG% 2>&1

echo [B4] DMF0052 골격/등록SQL/PKG + 파이프라인 드라이런
echo ==== [B4] DMF0052 >> %LOG%
node tools\Harness\pipeline.js DMF0052 --no-claude >> %LOG% 2>&1
echo     exit %ERRORLEVEL% >> %LOG%

echo [B5] E2E 계정/스펙 생성
echo ==== [B5] E2E gen >> %LOG%
pushd tools\E2E
python gen-accounts.py >> ..\..\%LOG% 2>&1
node gen-e2e.js --all >> ..\..\%LOG% 2>&1
popd

echo [B6] 생성기 스냅샷 기준선 (전 화면 — 수 분)
echo ==== [B6] snapshot >> %LOG%
node tools\Harness\snapshot.js --update >> %LOG% 2>&1
echo     exit %ERRORLEVEL% >> %LOG%

echo ==== 끝 %date% %time% >> %LOG%
echo.
echo 완료. 로그: %LOG%
findstr /c:"====" /c:"exit" /c:"RESULT" /c:"대사표" /c:"GAP:" /c:"PASS" /c:"NEEDS" /c:"스펙" /c:"기준선" %LOG%
endlocal
