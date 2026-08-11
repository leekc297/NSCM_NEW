#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS 에서 DM_PLN_SALES_ETC_REPORT_C 에 **쓰는** 주체를 전수 추적 (조회 전용)
   목적: 다중 행 셀 배분 규칙 / DATA_SEQ 채번 규칙의 AS-IS 원본 확보
   ⚠ 정규식 1개 금지 — DML 4종 × 별칭/괄호/개행 변형 + 화면 .cs 호출부 동시 추적
"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

DDL = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL")
TBL = "DM_PLN_SALES_ETC_REPORT_C"

def sec(t): print("\n" + "=" * 116); print(t); print("=" * 116)

sec(f"[1] {TBL} 에 DML 을 거는 AS-IS 프로시저 전수")
hits = {}   # proc -> list[(file, line, op, text)]
for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
    text = io.open(f, encoding="utf-8", errors="ignore").read()
    procs = [(m.start(), m.group(1)) for m in
             re.finditer(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[(\w+)\]', text, re.I)]
    lines = text.splitlines()
    starts = [text[:p].count("\n") + 1 for p, _ in procs]
    names = [n for _, n in procs]

    def owner(ln):
        nm = "(파일 선두)"
        for s, n in zip(starts, names):
            if s <= ln: nm = n
            else: break
        return nm

    for i, ln in enumerate(lines, 1):
        s = ln.strip()
        if s.startswith('--'):
            continue
        m = re.search(r'\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\b[^\n]*?\b' + TBL + r'\b', s, re.I)
        if m:
            hits.setdefault(owner(i), []).append((f.name, i, m.group(1).upper(), s[:150]))

for proc in sorted(hits):
    print(f"\n  ### {proc}   ({len(hits[proc])} DML)")
    for fn, ln, op, s in hits[proc]:
        print(f"     {fn} L{ln:<8} {op:<12} {s}")
if not hits:
    print("  (DML 없음)")

sec(f"[2] {TBL} 언급(읽기 포함) 프로시저 요약")
mention = {}
for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
    text = io.open(f, encoding="utf-8", errors="ignore").read()
    procs = [(m.start(), m.group(1)) for m in
             re.finditer(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[(\w+)\]', text, re.I)]
    starts = [text[:p].count("\n") + 1 for p, _ in procs]
    names = [n for _, n in procs]
    def owner(ln):
        nm = "(파일 선두)"
        for s, n in zip(starts, names):
            if s <= ln: nm = n
            else: break
        return nm
    for i, ln in enumerate(text.splitlines(), 1):
        if TBL in ln.upper():
            mention[owner(i)] = mention.get(owner(i), 0) + 1
for k in sorted(mention, key=lambda x: -mention[x]):
    tag = "  ← 쓰기 있음" if k in hits else ""
    print(f"  {k:<52} {mention[k]:>4} 회{tag}")

sec("[3] DATA_SEQ 를 채우는 AS-IS 구문 (채번 규칙)")
for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
    text = io.open(f, encoding="utf-8", errors="ignore").read()
    for i, ln in enumerate(text.splitlines(), 1):
        if re.search(r'DATA_SEQ', ln, re.I) and not ln.strip().startswith('--'):
            print(f"  {f.name} L{i:<8} {ln.strip()[:150]}")
