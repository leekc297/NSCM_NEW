# -*- coding: utf-8 -*-
"""DESCNULL 배포 — library cache pin 이 풀릴 때까지 재시도 (최대 40분)

⚠ 매 시도마다 **live body 를 다시 dump 해서 patch** 한다.
   같은 패키지를 튜닝 서브에이전트도 만지고 있어, 낡은 배포본을 그대로 쓰면 그쪽 변경을 덮어쓴다.
"""
import subprocess
import sys
import time
import pathlib

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = pathlib.Path(__file__).resolve().parent
SCRIPT = HERE / "dmf0044_verlist_desc_null_apply.py"
DEADLINE = time.time() + 40 * 60
attempt = 0

while time.time() < DEADLINE:
    attempt += 1
    print("\n===== 시도 %d =====" % attempt, flush=True)
    ok = True
    for step in ("--dump", "--patch", "--deploy"):
        r = subprocess.run([sys.executable, str(SCRIPT), step], capture_output=True, text=True,
                           encoding="utf-8", errors="replace")
        tail = (r.stdout or "").strip().splitlines()[-3:]
        for line in tail:
            print("  %s %s" % (step, line), flush=True)
        if r.returncode != 0:
            err = (r.stderr or "").strip().splitlines()[-1:] or ["(stderr 없음)"]
            print("  %s FAILED: %s" % (step, err[0]), flush=True)
            ok = False
            break
    if ok:
        print("\n✅ DESCNULL 배포 성공 (시도 %d)" % attempt, flush=True)
        sys.exit(0)
    time.sleep(60)

print("\n⛔ 40분 내 배포 실패 — 잠금 미해제", flush=True)
sys.exit(1)
