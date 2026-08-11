#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS 파리티 확인 — GET_SALES_REPORTS_DATA 가 data_type 별로 읽는 표 + SAVE 가 쓰는 표"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DDL = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL")
for TARGET in ("DMF0044_GET_SALES_REPORTS_DATA", "DMF0044_SAVE_SALES_PLAN_REPORT_C"):
    for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
        text = io.open(f, encoding="utf-8", errors="ignore").read()
        m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[' + TARGET + r'\]', text, re.I)
        if not m:
            continue
        start = m.start()
        nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', text[start + 10:], re.I)
        end = start + 10 + (nxt.start() if nxt else len(text) - start - 10)
        body = text[start:end]
        base = text[:start].count("\n") + 1
        print("\n" + "=" * 112)
        print(f"### {TARGET}   ({f.name}, {len(body.splitlines()):,}행)")
        print("=" * 112)
        for i, ln in enumerate(body.splitlines(), base):
            if re.search(r'(FROM|INTO|UPDATE|MERGE)\s+.*DM_PLN_SALES\w*|@p_data_type\s*(<>|=)\s*', ln, re.I):
                print(f"  {i:7d} | {ln.strip()[:160]}")
        break
    else:
        print(f"\n[미발견] {TARGET}")
