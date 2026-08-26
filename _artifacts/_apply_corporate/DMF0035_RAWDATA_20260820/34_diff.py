# -*- coding: utf-8 -*-
"""값 동등성 판정 — 두 캡처의 rc1/rc2/rc3 **전행 완전 일치** 검사. 사용: 34_diff.py <BEFORE> <AFTER>"""
import io
import json
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_RAWDATA_20260820"
pb, pa = sys.argv[1], sys.argv[2]
b = json.load(open(f"{BASE}\\{pb}_capture.json", encoding="utf-8"))
a = json.load(open(f"{BASE}\\{pa}_capture.json", encoding="utf-8"))
assert set(b) == set(a), "케이스 집합 불일치"

print(f"{'케이스':<20} {'판정':<6} {'rc1':>18} {'rc2':>9} {'rc3':>9}   {pb}s -> {pa}s")
fail = 0
for name in sorted(b):
    B, A = b[name], a[name]
    if not (B["ok"] and A["ok"]):
        print(f"{name:<20} FAIL   ok={B['ok']}/{A['ok']}  {B.get('error','')}{A.get('error','')}")
        fail += 1
        continue
    same, cells = True, []
    for rc in ("rc1", "rc2", "rc3"):
        rb, ra = B["data"][rc], A["data"][rc]
        nb = len(rb) if rb is not None else -1
        na = len(ra) if ra is not None else -1
        eq = (rb == ra)
        same &= eq
        cells.append(f"{nb}={na} {'OK' if eq else 'MISMATCH'}")
        if not eq and rb is not None and ra is not None:
            sb = {json.dumps(r, sort_keys=True, ensure_ascii=False) for r in rb}
            sa = {json.dumps(r, sort_keys=True, ensure_ascii=False) for r in ra}
            for x in list(sb - sa)[:3]:
                print(f"      BEFORE only: {x[:230]}")
            for x in list(sa - sb)[:3]:
                print(f"      AFTER  only: {x[:230]}")
    print(f"{name:<20} {'PASS' if same else 'FAIL':<6} {cells[0]:>18} {cells[1]:>9} {cells[2]:>9}   "
          f"{B['elapsed_s']} -> {A['elapsed_s']}")
    fail += (0 if same else 1)

print(f"\n{'[OK] 전 케이스 전행 완전 일치' if fail == 0 else f'[NG] {fail} 케이스 불일치 — 원복 필요'}")
sys.exit(1 if fail else 0)
