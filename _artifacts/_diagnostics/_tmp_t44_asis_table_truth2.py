#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS 정본 확정 (2) — DMF0044 가 호출하는 3 SP 가 다루는 표 전수 (DM. 접두 제거)"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DDL = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL")
SPS = ["DMF0044_GET_SALES_REPORTS_DATA",
       "DMF0044_SAVE_SALES_PLAN_REPORT_C",
       "DMF0044_SAVE_SALES_PLAN_REPORT_C_CF"]

allddl = {f.name: io.open(f, encoding="utf-8", errors="ignore").read()
          for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql"))}

def proc_body(sp):
    for fn, txt in allddl.items():
        # 정확 매칭 — _CF 가 _C 에 걸리지 않도록 종료 대괄호까지 포함
        m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[' + re.escape(sp) + r'\]', txt, re.I)
        if not m:
            continue
        start = m.start()
        nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', txt[start + 10:], re.I)
        end = start + 10 + (nxt.start() if nxt else len(txt) - start - 10)
        return fn, txt[start:end], txt[:start].count("\n") + 1
    return None, None, None

for sp in SPS:
    fn, body, base = proc_body(sp)
    print("\n" + "=" * 118)
    print(f"### {sp}")
    print("=" * 118)
    if not body:
        print("  ⛔ DDL 미발견")
        continue
    print(f"  파일 {fn} / {len(body.splitlines()):,}행 / 시작 L{base}\n")
    writes, reads = [], []
    for i, ln in enumerate(body.splitlines(), base):
        s = ln.strip()
        if s.startswith('--'):
            continue
        for m in re.finditer(r'\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\s+(?:\[dbo\]\.)?\[?(\w*DM_PLN_SALES\w*|\w*ETC_REPORT\w*)\]?', s, re.I):
            writes.append((i, m.group(1).upper(), m.group(2), s[:120]))
        for m in re.finditer(r'\b(FROM|JOIN)\s+(?:\[dbo\]\.)?\[?(\w*DM_PLN_SALES\w*|\w*ETC_REPORT\w*)\]?', s, re.I):
            reads.append((i, m.group(2), s[:120]))
    print(f"  ── 쓰기 (DML) {len(writes)}건")
    for i, op, tbl, s in writes:
        print(f"     {i:7d} | {op:<12} {tbl}")
    print(f"\n  ── 읽기 (FROM/JOIN) {len(reads)}건")
    seen = set()
    for i, tbl, s in reads:
        if tbl in seen:
            continue
        seen.add(tbl)
        print(f"     {i:7d} | {tbl}   (첫 출현)")
    print(f"     읽는 표 종류: {sorted(seen)}")
    # 데이터타입 분기
    print("\n  ── @p_data_type 분기")
    for i, ln in enumerate(body.splitlines(), base):
        if re.search(r'@p_data_type', ln, re.I) and not ln.strip().startswith('--'):
            print(f"     {i:7d} | {ln.strip()[:130]}")

print("\n" + "#" * 118)
print("### 결론 요약")
print("#" * 118)
