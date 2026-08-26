# -*- coding: utf-8 -*-
"""before/after 값 동등성 대조표 — rc1 전행(순서·집합) + GTT 전행 서버측 해시 + 성적."""
import io
import json
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
b = json.load(open("cap_before.json", encoding="utf-8"))
a = json.load(open("cap_after.json", encoding="utf-8"))

# ITEM_SINGLE_V 는 P4(선행축소)로 원문 행수가 의도적으로 줄어든다 → 등가 판정 축은 '소비 슬라이스'.
#   원문 행수는 INFO 로만 표시하고 PASS/FAIL 에 넣지 않는다.
GT = ["GT_DM51_SCM_MST_SITE_ITEM", "SINGLE_V_CONSUMED", "GT_DM51_RAW_DATA",
      "GT_DM51_SCM_CITY", "GT_DM22_SELECT_MEASURE", "GT_DM22_V_VERSION_NO"]
SH = ["SITE_ITEM", "SGLV_소비분", "RAW_DATA", "SCM_CITY", "MEASURE", "VERSION"]

print(f"{'케이스':26} {'rc1 행수':>16} {'컬럼':>5} {'순서':>5} {'집합':>5} | " +
      " ".join(f"{s:>10}" for s in SH) + f" | {'초 B→A':>15}")
print("-" * 150)
allok = True
for k in b:
    if k not in a:
        print(f"{k:26} (after 누락)")
        allok = False
        continue
    B, A = b[k], a[k]
    rows = f"{B['rows']}→{A['rows']}" + ("" if B["rows"] == A["rows"] else " X")
    cols = "OK" if B["cols"] == A["cols"] else "FAIL"
    ho = "OK" if B["hash_ordered"] == A["hash_ordered"] else "FAIL"
    hs = "OK" if B["hash_sorted"] == A["hash_sorted"] else "FAIL"
    gs = []
    for g in GT:
        same = (B[g]["cnt"] == A[g]["cnt"] and B[g]["h1"] == A[g]["h1"]
                and B[g]["h2"] == A[g]["h2"] and B[g]["distinct"] == A[g]["distinct"])
        gs.append("OK" if same else "FAIL")
    if B["rows"] != A["rows"] or "FAIL" in [cols, ho, hs] + gs:
        allok = False
    sv = f"{B['GT_DM22_DM_MST_ITEM_SINGLE_V']['cnt']}→{A['GT_DM22_DM_MST_ITEM_SINGLE_V']['cnt']}"
    print(f"{k:26} {rows:>16} {cols:>5} {ho:>5} {hs:>5} | " + " ".join(f"{x:>10}" for x in gs) +
          f" | {B['elapsed']:6.2f}→{A['elapsed']:<6.2f} | SGLV원문 {sv}")
print("-" * 150)
print("\n[값 동등성] " + ("전 케이스 PASS — rc1 컬럼목록·행수·정렬순 전행해시·멀티셋 전행해시 + GTT 6종 전행 일치"
                       if allok else "FAIL — 원복 필요"))
sys.exit(0 if allok else 1)
