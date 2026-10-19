@echo off
chcp 65001 >nul
REM E2E 일괄 (노트북): 의존성 설치확인 -> 계정/스펙 생성 -> 실행 -> 리포트
REM 사용: run-e2e.cmd [smoke|crud|auth|all] [화면ID ...]      (기본 smoke, 화면ID 없으면 Doc\gen 전체)
REM 선행: FE(http://127.0.0.1:5173) / BE(http://localhost:8080, profile local|dev — /sso/dev-login 활성) 기동
setlocal
cd /d %~dp0
set KIND=%1
if "%KIND%"=="" set KIND=smoke
set LOG=C:\Projects\NSCM\Doc\e2e\_run.log
if not exist C:\Projects\NSCM\Doc\e2e\results mkdir C:\Projects\NSCM\Doc\e2e\results
echo ==== %date% %time% run-e2e %* >> %LOG%
REM 설치는 자동으로 하지 않는다(외부망 npm/브라우저 다운로드 금지 — Local 환경 보호). node_modules 는 VM 에서 설치해 복사해 둔 순수 JS 모듈.
if not exist node_modules\@playwright\test\cli.js (
  echo [중단] tools\E2E\node_modules 없음 — 자동 설치하지 않습니다. Claude 에게 node_modules 복사를 요청하세요.
  exit /b 2
)
if not exist accounts.json python gen-accounts.py >> %LOG% 2>&1
shift
set IDS=
:loop
if not "%1"=="" ( set IDS=%IDS% %1 & shift & goto loop )
node probe-accounts.js >> %LOG% 2>&1 || echo [WARN] dev-login 가능한 계정 없음(BE 미기동 또는 계정 미등록) — 스펙은 defaultAccount 로 생성
if "%IDS%"=="" ( node gen-e2e.js --all >> %LOG% 2>&1 ) else ( node gen-e2e.js %IDS% >> %LOG% 2>&1 )
curl -s -o nul -w "FE %%{http_code}\n" http://127.0.0.1:5173/ || echo [WARN] FE 미기동
curl -s -o nul -w "BE %%{http_code}\n" http://localhost:8080/sso/dev-login?id=_probe_ || echo [WARN] BE 미기동(또는 dev-login 비활성)
set PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
if /i "%KIND%"=="all" ( node node_modules\@playwright\test\cli.js test >> %LOG% 2>&1 ) else ( node node_modules\@playwright\test\cli.js test --grep @%KIND% >> %LOG% 2>&1 )
node report.js
echo 로그: %LOG%
endlocal
