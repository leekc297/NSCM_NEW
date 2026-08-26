# -*- coding: utf-8 -*-
"""값 동등성 판정 — BEFORE/AFTER 캡처 전행 완전 일치 검사."""
import io
import json
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_VERPUSH_20260820"
b = json.load(open(BASE + r"\BEFORE_capture.json", encoding="utf-8"))
a = json.load(open(BASE + r"\AFTER_capture.json", encoding="utf-8"))

assert set(b) == set(a), "케이스 집합 불일치"
fail = 0
for name in sorted(b):
    B, A = b[name], a[name]
    if not (B["ok"] and A["ok"]):
        print(f"  {name:<18} SKIP/FAIL ok={B['ok']}/{A['ok']}")
        fail += 1
        continue
    same_all, detail = True, []
    for rc in ("rc1", "rc2", "rc3"):
        rb, ra = B["data"][rc], A["data"][rc]
        nb, na = (len(rb) if rb is not None else -1), (len(ra) if ra is not None else -1)
        eq = (rb == ra)
        same_all &= eq
        detail.append(f"{rc} {nb}={na} {'OK' if eq else 'MISMATCH'}")
        if not eq and rb is not None and ra is not None:
            sb = {json.dumps(r, sort_keys=True, ensure_ascii=False) for r in rb}
            sa = {json.dumps(r, sort_keys=True, ensure_ascii=False) for r in ra}
            for x in list(sb - sa)[:3]:
                print(f"      BEFORE only: {x[:220]}")
            for x in list(sa - sb)[:3]:
                print(f"      AFTER  only: {x[:220]}")
    print(f"  {name:<18} {'PASS' if same_all else 'FAIL'}  "
          f"[{' | '.join(detail)}]  {B['elapsed_s']}s -> {A['elapsed_s']}s")
    fail += (0 if same_all else 1)

print(f"\n{'[OK] 전 케이스 전행 완전 일치' if fail == 0 else f'[NG] {fail} 케이스 불일치 — 원복 필요'}")
sys.exit(1 if fail else 0)
