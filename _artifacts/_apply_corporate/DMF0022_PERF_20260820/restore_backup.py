# -*- coding: utf-8 -*-
"""00_BACKUP 원복 — dump_pkg.py 재실행으로 백업 파일이 패치본으로 덮어써진 사고 정정.

01_PATCHED_A 에서 [E20260820-D22PREREDUCE] 삽입분을 **정확히 역치환**해 원본을 복원하고,
직전 세션 백업(DMF0035_DS2_20260820/01_PATCHED_PKG_DMF0022_BODY.sql)과 바이트 대조로 실증한다.
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
BASE = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0022_PERF_20260820"
REF = (r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_DS2_20260820"
       r"\01_PATCHED_PKG_DMF0022_BODY.sql")

a = open(BASE + r"\01_PATCHED_A_PKG_DMF0022_BODY.sql", encoding="utf-8").read().splitlines()
out, i, removed = [], 0, 0
while i < len(a):
    l = a[i]
    if l.strip() == "WHERE DIVISION_ID = p_division_id" and "E20260820-D22PREREDUCE" in a[i + 1]:
        out.append(l)                       # 원본 1줄만 남기고
        j = i + 1
        while j < len(a) and "WHERE R.DIVISION_ID = p_division_id)" not in a[j]:
            j += 1
        removed += j - i                    # 주석 5 + 술어 3 = 8줄 제거
        i = j + 1
        continue
    if l.strip() == "WHERE 1=1" and "E20260820-D22PREREDUCE" in a[i + 1]:
        out.append(l)
        j = i + 1
        while j < len(a) and "AND R.SCM_SITE_ID = A.SCM_SITE_ID)" not in a[j]:
            j += 1
        removed += j - i                    # 주석 5 + 술어 4 = 9줄 제거
        i = j + 1
        continue
    out.append(l)
    i += 1

txt = "\n".join(out) + "\n"
assert len(out) == len(a) - 17, f"{len(a)} - {len(out)} = {len(a)-len(out)}"
assert "E20260820-D22PREREDUCE" not in txt
assert txt.count("E20260820-DS2") == 1 and txt.count("v_measure_sheet") == 6
assert len(out) == 3672, len(out)

ref = open(REF, encoding="utf-8").read()
ref_body = ref[ref.upper().index("PACKAGE BODY"):] if ref.upper().startswith("--") else ref
same = ref.strip() == txt.strip()
print(f"[restore] 3672 lines 복원 (제거 {removed}줄) / 직전세션 백업과 바이트 동일: {same}")
if not same:
    r = ref.strip().splitlines()
    t = txt.strip().splitlines()
    print(f"  ref {len(r)} lines / restored {len(t)} lines")
    for k in range(min(len(r), len(t))):
        if r[k] != t[k]:
            print(f"  첫 차이 L{k+1}\n   ref> {r[k][:120]!r}\n   new> {t[k][:120]!r}")
            break
open(BASE + r"\00_BACKUP_PKG_DMF0022_BODY.sql", "w", encoding="utf-8").write(txt)
print("[written] 00_BACKUP_PKG_DMF0022_BODY.sql")
