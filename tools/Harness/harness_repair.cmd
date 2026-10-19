@echo off
chcp 65001 >nul
REM 자동 수선 루프: 골격 생성 -> Claude Code 채움 -> 게이트(--final: 매핑표/대사/tsc/eslint) -> 실패 findings 붙여 재시도(기본 3회)
REM 사용: harness_repair.cmd DMF0052 [DMF0003 ...]      또는   harness_repair.cmd --batch ids.txt
cd /d C:\Projects\NSCM
echo [%date% %time%] repair-loop %* >> Doc\gen\harness-log.txt
node tools\Harness\repair-loop.js %* --max 3 >> Doc\gen\harness-log.txt 2>&1
type Doc\gen\_repair_summary.csv
echo 상세: Doc\gen\^<ID^>\REPAIR.md
