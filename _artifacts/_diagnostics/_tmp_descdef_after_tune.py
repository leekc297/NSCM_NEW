# -*- coding: utf-8 -*-
"""DESCDEF 재적용 — TUNE-T 배포로 덮인 것을 현재 live body 위에 다시 올린다.

⚠ 2026-08-10 병렬 배포 사고: DESCDEF(18:56:07) 와 TUNE-T(18:57:05) 가 같은 DESCNULL 베이스에서
   1분 차로 생성돼 서로를 포함하지 않았고, 나중에 배포된 TUNE-T 가 DESCDEF 를 덮었다.
   ⇒ 낡은 배포본을 쓰지 말고 **반드시 live 재dump 후 패치**한다.
   ⇒ 튜닝 서브에이전트가 같은 패키지를 만지므로 **직렬**로만 실행한다.
"""
import subprocess
import sys
import pathlib

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

HERE = pathlib.Path(__file__).resolve().parent
SCRIPT = HERE / "dmf0044_desc_default_apply.py"

for step in ("--dump", "--patch", "--deploy"):
    r = subprocess.run([sys.executable, str(SCRIPT), step], capture_output=True, text=True,
                       encoding="utf-8", errors="replace")
    print("===== %s (rc=%d) =====" % (step, r.returncode))
    print((r.stdout or "").rstrip())
    if r.returncode != 0:
        print("STDERR:", (r.stderr or "").strip()[-400:])
        sys.exit(r.returncode)
print("\n✅ DESCDEF 재적용 완료")
