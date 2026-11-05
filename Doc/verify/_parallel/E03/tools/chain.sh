#!/usr/bin/env bash
# E03 측정 체인 — 부하 신호 나오면 E2E 중지
cd /c/Projects/NSCM
BE="C:/Users/ejene/AppData/Local/Temp/claude/c--Projects-NSCM/df35bb3d-69d0-477c-a01d-67a99b5ba4ea/scratchpad/be_start.log"
base=$(grep -ac 'Connection is not available' "$BE")
while IFS='|' read -r id name grep mut acct; do
  [ -z "$id" ] && continue
  now=$(grep -ac 'Connection is not available' "$BE")
  if [ "$now" != "$base" ]; then echo "[STOP] $(date '+%H:%M:%S') HikariPool 연결 불가 ${base}→${now}"; break; fi
  EG_ACCT_MAX="$acct" bash Doc/verify/_parallel/E03/tools/run_screen.sh "$id" "$name" "${grep//#/|}" "$mut" 2>&1 | cut -c1-600
  if grep -aqE 'ERR_CONNECTION|로그인 실패|net::ERR_' "Doc/verify/_parallel/E03/runs/${name}_${id}/run.log"; then echo "[STOP] $(date '+%H:%M:%S') 부하 신호 $id $name"; grep -aE 'ERR_CONNECTION|로그인 실패|net::ERR_' "Doc/verify/_parallel/E03/runs/${name}_${id}/run.log" | head -3 | cut -c1-200; break; fi
done < "$1"
echo "[chain-end] $(date '+%H:%M:%S')"
