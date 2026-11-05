#!/usr/bin/env bash
# 부하 중지: 프로세스를 죽이지 않고 다음 E02 실행을 막는다 — verify DMF0005 잠금이 비는 즉시 이 셸(살아 있는 PID)로 잡아 batch2 의 남은 run.sh 가 rc=92 로 그냥 끝나게 한다.
# batch2 가 BATCH2_END 를 찍으면 잠금을 풀고 끝낸다.
L=/c/Projects/NSCM/Doc/e2e/_run.verify.DMF0005.lock
B=/c/Projects/NSCM/Doc/verify/_parallel/E02/runs/_batch2.txt
WP=$(cat /proc/$$/winpid)
held=0
while ! grep -q "BATCH2_END" "$B"; do
  if [ ! -e "$L" ]; then
    printf '{"pid":%s,"started":"%s","startedMs":0,"runId":"hold","args":"verify DMF0005 (E02 부하 중지 보류)"}' "$WP" "$(date -u +%FT%TZ)" > "$L"; held=1
    echo "[HOLD $(date +%H:%M:%S)] 잠금 보유"
  fi
  sleep 0.3
done
[ "$held" = 1 ] && rm -f "$L"
echo "[HOLD $(date +%H:%M:%S)] 종료"
