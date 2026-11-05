#!/usr/bin/env bash
# E03 격리 실행 1건: run_screen.sh <ID> <run명> <grep> [EG_MUT] — 화면 잠금 + 부하 신호 grep(판정은 결과 파일)
ID="$1"; NAME="$2"; GREP="$3"; MUTV="$4"
FLAG=/c/Projects/NSCM/Doc/verify/_parallel/E03/tools/STOP.flag
[ -f "$FLAG" ] && { echo "[STOP-FLAG] $ID $NAME 건너뜀"; exit 5; }
cd /c/Projects/NSCM/tools/E2E || exit 9
R="../../Doc/verify/_parallel/E03/runs/${NAME}_${ID}"; mkdir -p "$R"
echo "[start] $ID $NAME $(date '+%H:%M:%S') grep=$GREP mut=$MUTV"
node runlock.js acquire verify "$ID" >/dev/null || { echo "[lock-busy] $ID"; exit 4; }
T0=$(date +%s)
EG_MUT="$MUTV" VERIFY_NO_SAVE=1 VERIFY_ID="$ID" CL_SELFTEST_BASE=1 CL_RESULTS="$R/e2e.json" E2E_RESULTS="$R" PLAYWRIGHT_JSON_OUTPUT_NAME="$R/results.json" \
  timeout "${EG_TIMEOUT:-2400}" node node_modules/@playwright/test/cli.js test eg_auth --grep "$GREP" --workers 1 --retries 0 --reporter=list > "$R/run.log" 2>&1
RC=$?
node runlock.js release verify "$ID"
T1=$(date +%s)
grep -aqE "ERR_CONNECTION|로그인 실패|net::ERR_" "$R/run.log" && { echo "[STOP] $(date +%H:%M:%S) 부하 신호 $ID $NAME" | tee -a "$FLAG"; }
echo "[end] $ID $NAME rc=$RC $(date '+%H:%M:%S') 소요 $((T1-T0))s"
grep -aE '^\s+(ok|x|-) +[0-9]+ |Timeout|ERR_CONNECTION|로그인 실패|\[LOAD' "$R/run.log" | cut -c1-170 | tail -12
python -I - "$R/e2e.json" <<'PY'
import json,sys,collections,os
p=sys.argv[1]
if not os.path.exists(p): print('결과 없음'); sys.exit()
r=json.load(open(p,encoding='utf-8'))
c=collections.Counter((x['eg'],x['result']) for x in r)
print(' '.join(f'{a}:{b}={n}' for (a,b),n in sorted(c.items())))
PY
