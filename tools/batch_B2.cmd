@echo off
chcp 65001 >nul
REM 재실행 묶음 (2026-10-19 09:58 보정분): 카탈로그(framework.js 경로 수정) + DMF0052 파이프라인 드라이런(메뉴 메타 반영: report/dmf0052)
cd /d C:\Projects\NSCM
if not exist Doc\_batch mkdir Doc\_batch
set LOG=Doc\_batch\B2_rerun.log
echo ==== %date% %time% > %LOG%
echo [1] 프레임워크 카탈로그
node tools\TobeFacts\framework.js --config tools\TobeFacts\tobefacts.json >> %LOG% 2>&1
echo [2] DMF0052 파이프라인 드라이런 (--no-claude)
node tools\Harness\pipeline.js DMF0052 --no-claude >> %LOG% 2>&1
echo [3] 대사표 갱신
node tools\Recon\recon.js >> %LOG% 2>&1
echo ==== 끝 %date% %time% >> %LOG%
findstr /c:"framework:" /c:"[OK]" /c:"[EXIT" /c:"PASS" /c:"NEEDS" /c:"대사표:" /c:"메뉴 메타" %LOG%
echo 로그: %LOG%
pause
