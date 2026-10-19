# -*- coding: utf-8 -*-
"""baseline_before.json vs baseline_after.json — 커서별 행수/DEPT 분포/해시 대사"""
import json, pathlib
S = pathlib.Path(__file__).parent
b = json.loads((S / "baseline_before.json").read_text(encoding="utf-8"))
a = json.loads((S / "baseline_after.json").read_text(encoding="utf-8"))
same = diff = 0
print(f"{'PROC|DIV':82s} {'cursor':6s} {'before':>8s} {'after':>8s} {'dept(b/a)':>14s} {'hash':>5s}")
for k in b:
    bb = b[k]; aa = a.get(k)
    if aa is None:
        print(f"{k:82s} (after 없음)"); continue
    if "error" in bb or "error" in aa:
        print(f"{k:82s} ERR  before={bb.get('error','-')[:60]} after={aa.get('error','-')[:60]}"); continue
    for cb, ca in zip(bb["cursors"], aa["cursors"]):
        rb, ra = cb.get("rows"), ca.get("rows")
        flag = "OK" if rb == ra else "DIFF"
        if rb == ra: same += 1
        else: diff += 1
        hb, ha = cb.get("hash"), ca.get("hash")
        h = "=" if hb and hb == ha else ("≠" if hb and ha else "-")
        d = f"{cb.get('dept_distinct')}/{ca.get('dept_distinct')}" if cb.get("dept_distinct") is not None else "-"
        print(f"{k:82s} c{cb['cursor']:<5d} {rb:>8} {ra:>8} {d:>14s} {h:>5s}  {flag}")
print(f"\n행수 동일 커서 = {same} / 상이 = {diff}")
