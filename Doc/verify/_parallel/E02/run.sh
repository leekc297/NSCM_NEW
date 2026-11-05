#!/usr/bin/env bash
# E02 격리 실행 — 화면 잠금(runlock verify <ID>) + 동시 상한 슬롯 + 부하 신호 점검 후 Playwright 1회.
#   사용: run.sh <ID> <라벨> [EG_CALLS] [EG_MODES] [CL_POPMUT] [ACCOUNT]
#   출력: Doc/verify/_parallel/E02/runs/<ID>_<라벨>_<시각>/ · 표준출력 마지막 줄에 폴더
set -u
ROOT=/c/Projects/NSCM; E2E=$ROOT/tools/E2E
ID=$1; LBL=$2; CALLS=${3:-}; MODES=${4:-}; MUT=${5:-}; ACC=${6:-}
BE_LOG="C:/Users/ejene/AppData/Local/Temp/claude/c--Projects-NSCM/df35bb3d-69d0-477c-a01d-67a99b5ba4ea/scratchpad/be_start.log"
OUT="$ROOT/Doc/verify/_parallel/E02/runs/${ID}_${LBL}_$(date +%H%M%S)"; mkdir -p "$OUT"
BE_CODE=$(curl -s -o /dev/null -m 10 -w '%{http_code}' http://localhost:8080/actuator/health); FE_CODE=$(curl -s -o /dev/null -m 10 -w '%{http_code}' http://localhost:5173/)
echo "[PRE $(date '+%H:%M:%S')] BE=$BE_CODE FE=$FE_CODE"
if [ "$BE_CODE" = "000" ] || [ "$FE_CODE" = "000" ]; then echo "[STOP] curl 000 — 부하 중지 조건"; exit 90; fi
HP=$(tail -c 200000 "$BE_LOG" 2>/dev/null | grep -c 'Connection is not available')
echo "[PRE] BE 로그 말미 HikariPool 타임아웃 $HP건"
cd "$E2E" || exit 91
node runlock.js acquire verify "$ID" >/dev/null || { echo "[LOCK] $ID 사용 중 — 실행 안 함"; exit 92; }
SLOT=""
for t in $(seq 1 60); do
  for i in 0 1 2; do if node runlock.js acquire slot "$i" >/dev/null 2>&1; then SLOT=$i; break 2; fi; done
  sleep 20
done
if [ -z "$SLOT" ]; then node runlock.js release verify "$ID"; echo "[SLOT] 20분 대기에도 빈 슬롯 없음"; exit 93; fi
# 잠금 PID = 이 셸의 Windows PID — acquire 가 기록한 임시 부모 PID 는 곧 사라져 다른 세션이 죽은 잠금으로 본다(runlock alive)
WP=$(cat /proc/$$/winpid 2>/dev/null); if [ -n "$WP" ]; then for L in "_run.verify.$(echo "$ID" | tr a-z A-Z).lock" "_run.slot.$SLOT.lock"; do node -e "const fs=require('fs'),p=require('path');const c=JSON.parse(fs.readFileSync(p.join(__dirname,'e2e.config.json'),'utf8').replace(/^\uFEFF/,''));const f=p.join(p.dirname(c.resultsDir),process.argv[1]);const j=JSON.parse(fs.readFileSync(f,'utf8'));j.pid=Number(process.argv[2]);fs.writeFileSync(f,JSON.stringify(j,null,2))" "$L" "$WP" 2>/dev/null; done; fi
echo "[LOCK] verify $ID · 슬롯 $SLOT · 시작 $(date '+%H:%M:%S')"
export VERIFY_NO_SAVE=1 VERIFY_ID="$ID" CL_SELFTEST_BASE=1 CL_RESULTS="$OUT/e2e.json" E2E_RESULTS="$OUT" PLAYWRIGHT_JSON_OUTPUT_NAME="$OUT/results.json" EG_CALLS="$CALLS" CL_POPMUT="$MUT" EG_DUMP="${EG_DUMP:-}" EG_GROUPS="${EG_GROUPS:-GRID,FILTER,COMBO,LAYOUT}" EG_META="${EG_META:-}"
if [ -n "$MODES" ]; then export EG_MODES="$MODES"; fi
if [ -n "$ACC" ]; then export E2E_ACCOUNT="$ACC"; fi
node node_modules/@playwright/test/cli.js test eg_popup --workers 1 --retries 0 --reporter=list,json > "$OUT/run.log" 2>&1
RC=$?
echo "[END $(date '+%H:%M:%S')] rc=$RC"
node runlock.js release slot "$SLOT"; node runlock.js release verify "$ID"
echo "[BE] 말미 HikariPool 타임아웃 $(tail -c 200000 "$BE_LOG" 2>/dev/null | grep -c 'Connection is not available')건 · 401 $(grep -c '401' "$OUT/run.log")건"
tail -6 "$OUT/run.log" | cut -c1-200
echo "$OUT"
