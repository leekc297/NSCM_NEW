#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS DMF0044_GET_SALES_REPORTS_DATA 의 EDIT_FLAG 식 원문 추출 (파리티 판정)
   쟁점: EDITFLAGSTD 가 `AND (DATA_TYPE='2')` 를 함께 제거하는데, 그게 AS-IS 인가?
   (2026-08-10 게이트에서 'div82 EDIT_FLAG 전 행 N = AS-IS 파리티' 로 확정된 바 있음)
"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DDL = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL")
TARGET = "DMF0044_GET_SALES_REPORTS_DATA"

for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
    text = io.open(f, encoding="utf-8", errors="ignore").read()
    m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[' + TARGET + r'\]', text, re.I)
    if not m:
        continue
    start = m.start()
    nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', text[start + 10:], re.I)
    end = start + 10 + (nxt.start() if nxt else len(text) - start - 10)
    body = text[start:end]
    print(f"[발견] {f.name}  프로시저 길이 {len(body.splitlines()):,}행\n")
    base = text[:start].count("\n") + 1
    for i, ln in enumerate(body.splitlines(), base):
        if re.search(r'EDIT_FLAG|v_group_id|DATA_TYPE\s*=\s*''?2', ln, re.I):
            print(f"  {i:7d} | {ln.strip()[:170]}")
    print("\n[문맥] EDIT_FLAG 주변 ±8행")
    for i, ln in enumerate(body.splitlines(), base):
        if re.search(r'EDIT_FLAG', ln, re.I):
            lo = max(0, i - base - 8); hi = min(len(body.splitlines()), i - base + 6)
            print(f"\n  --- L{i} ---")
            for k in range(lo, hi):
                print(f"    {base+k:7d} | {body.splitlines()[k].rstrip()[:170]}")
    break
else:
    print(f"[미발견] {TARGET} — 파일명/철자 확인 필요")
