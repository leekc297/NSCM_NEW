@echo off
chcp 65001 >nul
REM 화면 ID 하나로 끝까지: FE 골격 -> 등록 SQL -> PKG 골격 -> FE 수선(Claude x3) -> PKG 이식(Claude x3) -> E2E 스펙 -> 대사표
REM 사용: harness_pipeline.cmd DMF0052 [--e2e] [--no-claude]
cd /d C:\Projects\NSCM
echo [%date% %time%] pipeline %* >> Doc\gen\harness-log.txt
node tools\Harness\pipeline.js %* --max 3 >> Doc\gen\harness-log.txt 2>&1
type Doc\gen\%1\PIPELINE.md | findstr /b /c:"# " /c:"페이지" /c:"- "
