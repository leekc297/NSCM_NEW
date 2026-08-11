#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS GET_SALES_REPORTS_DATA 두 분기의 WHERE 절 원문 — DATA_TYPE 필터 유무 확정"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

f = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP1_DDL.sql")
lines = io.open(f, encoding="utf-8", errors="ignore").read().splitlines()

def dump(tag, a, b):
    print("\n" + "=" * 112); print(f"### {tag}  (L{a}~L{b})"); print("=" * 112)
    for i in range(a - 1, b):
        print(f"  {i+1:7d} | {lines[i].rstrip()[:165]}")

# 분기1: FROM DM_PLN_SALES_PLAN_REPORT_C (L146374) 이후 WHERE ~ GROUP BY
dump("분기1 (Cutoff / @p_data_type <> '2')  FROM ~ GROUP BY", 146374, 146434)
# 분기2: FROM DM_PLN_SALES_ETC_REPORT_C (L146491) 이후
dump("분기2 (ETC / @p_data_type <> '1')  FROM ~ GROUP BY", 146491, 146545)

print("\n" + "#" * 112)
print("### DATA_TYPE 관련 라인만 추출 (프로시저 전체)")
print("#" * 112)
for i in range(145934, 146643):
    if i - 1 < len(lines) and re.search(r'DATA_TYPE', lines[i-1], re.I):
        print(f"  {i:7d} | {lines[i-1].strip()[:160]}")
