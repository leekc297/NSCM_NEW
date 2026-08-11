#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""AS-IS 정본 확정 — DMF0044 가 실제로 어느 표를 읽고 어느 표에 쓰는가.
   ① 화면 .cs 에서 호출하는 SP 전수 (DataType 분기 포함)
   ② 그 SP 들이 DDL 에서 실제로 다루는 표 전수 (읽기/쓰기 구분)
   ⚠ 정규식 1개 금지 — 다중 패턴(직접호출/변수/헬퍼) + 문맥 출력 (anti-simplification)
"""
import io, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

CS = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\06_UIL\domain_DM\GSCM.DM.Forms.UIL"
                  r"\Plan\DMF0044_Sales_Reports\DMF0044_Sales_Reports.cs")
DDL = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source\DB_DDL")

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

sec(f"[①] 화면 .cs — 존재/규모")
print(f"  {CS}  존재={CS.exists()}")
if not CS.exists():
    # 대체 경로 탐색
    root = pathlib.Path(r"C:\Projects\NSCM\Doc\_legacy_source")
    for c in root.rglob("DMF0044_Sales_Reports.cs"):
        print("  발견:", c)
        CS = c
        break
text = io.open(CS, encoding="utf-8", errors="ignore").read()
lines = text.splitlines()
print(f"  {len(lines):,} 행")

sec("[①-a] .cs 안의 SP/프로시저 이름 전수 (다중 패턴)")
pats = [
    (r'"(DMF\w+)"', '문자열 리터럴 SP명'),
    (r'"(UP_\w+)"', 'UP_ 계열'),
    (r'"(PR_\w+)"', 'PR_ 계열'),
    (r'ProcedureName\s*=\s*"([^"]+)"', 'ProcedureName='),
    (r'FoxDataRequest\s*\(\s*"([^"]+)"', 'FoxDataRequest'),
]
found = {}
for pat, why in pats:
    for m in re.finditer(pat, text):
        nm = m.group(1)
        ln = text[:m.start()].count("\n") + 1
        found.setdefault(nm, []).append((ln, why))
for nm in sorted(found):
    locs = found[nm]
    print(f"  {nm:<48} {len(locs):>3}회  (첫 L{locs[0][0]}, {locs[0][1]})")

sec("[①-b] DataType(ETC/Cutoff) 분기와 저장 SP 호출의 문맥")
KEY = re.compile(r'(SAVE_SALES_PLAN_REPORT_C|_CF|DataType|dataType|cboDataType|ETC|Cutoff)', re.I)
hits = [i for i, ln in enumerate(lines, 1)
        if re.search(r'DMF0044_SAVE\w*|DMF0049_SAVE\w*|SAVE_SALES_PLAN_REPORT_C', ln, re.I)]
for h in hits:
    lo, hi = max(0, h - 14), min(len(lines), h + 4)
    print(f"\n  --- L{h} 문맥 ---")
    for k in range(lo, hi):
        mark = ">>" if k + 1 == h else "  "
        print(f"  {mark} {k+1:6d} | {lines[k].rstrip()[:150]}")

sec("[②] 위 SP 들이 DDL 에서 다루는 표 (읽기 FROM/JOIN · 쓰기 MERGE/INSERT/UPDATE/DELETE)")
SPS = [n for n in found if n.upper().startswith(('DMF0044', 'DMF0049'))]
allddl = {}
for f in sorted(DDL.glob("AsIs_LGCE_SCMDEV_SP*_DDL.sql")):
    allddl[f.name] = io.open(f, encoding="utf-8", errors="ignore").read()

for sp in sorted(SPS):
    for fn, txt in allddl.items():
        m = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.\[' + re.escape(sp) + r'\]', txt, re.I)
        if not m:
            continue
        start = m.start()
        nxt = re.search(r'CREATE\s+PROCEDURE\s+\[dbo\]\.', txt[start + 10:], re.I)
        end = start + 10 + (nxt.start() if nxt else len(txt) - start - 10)
        body = txt[start:end]
        base = txt[:start].count("\n") + 1
        writes, reads = [], []
        for i, ln in enumerate(body.splitlines(), base):
            if re.search(r'\b(MERGE\s+INTO|INSERT\s+INTO|UPDATE|DELETE\s+FROM)\b[^\n]*\b(DM_PLN_SALES\w+)', ln, re.I):
                writes.append((i, ln.strip()[:130]))
            elif re.search(r'\b(FROM|JOIN)\b[^\n]*\b(DM_PLN_SALES\w+)', ln, re.I):
                reads.append((i, ln.strip()[:130]))
        print(f"\n  ### {sp}  ({fn}, {len(body.splitlines()):,}행)")
        print(f"    [쓰기 {len(writes)}]")
        for i, s in writes:
            print(f"      {i:7d} | {s}")
        print(f"    [읽기 {len(reads)}]")
        for i, s in reads[:12]:
            print(f"      {i:7d} | {s}")
        if len(reads) > 12:
            print(f"      ... 외 {len(reads)-12}")
        break
    else:
        print(f"\n  ### {sp} — DDL 미발견")
