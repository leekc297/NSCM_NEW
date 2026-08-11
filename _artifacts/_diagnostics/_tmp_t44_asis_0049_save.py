#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS DMF0049_SAVE_SALES_ETC_REPORT_C 저장 흐름 원문 — ETC_REPORT_C 반영 규칙 정본 확보"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

f = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL\AsIs_LGCE_SCMDEV_SP1_DDL.sql")
text = io.open(f, encoding="utf-8", errors="ignore").read()
m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[DMF0049_SAVE_SALES_ETC_REPORT_C\]', text, re.I)
start = m.start()
nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', text[start + 10:], re.I)
end = start + 10 + (nxt.start() if nxt else 0)
body = text[start:end]
base = text[:start].count("\n") + 1
lines = body.splitlines()
print(f"[proc] DMF0049_SAVE_SALES_ETC_REPORT_C  L{base} ~ L{base+len(lines)-1}  ({len(lines):,}행)\n")

print("=" * 116); print("### DML / 흐름 골격 (주석 제외)"); print("=" * 116)
for i, ln in enumerate(lines, base):
    s = ln.strip()
    if not s or s.startswith('--'):
        continue
    if re.search(r'\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE\s+|DELETE\s+FROM|IF\s+EXISTS|SELECT\s+@v_max_seq|DENSE_RANK|ACTIVE_FLAG\s*=|BEGIN\s+TRAN|COMMIT|ROLLBACK)\b', s, re.I):
        print(f"  {i:7d} | {s[:150]}")

print("\n" + "=" * 116); print("### 핵심 구간 원문 (DATA_SEQ 분기 L168750~168890)"); print("=" * 116)
for i in range(168740, 168900):
    k = i - base
    if 0 <= k < len(lines):
        print(f"  {i:7d} | {lines[k].rstrip()[:165]}")
