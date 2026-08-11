#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""미적용 EDITFLAGSTD 패치가 무엇을 바꾸려 했는지 diff (파일 대조 — DB 불필요)
   + 라이브에 그 변경이 있는지 확인"""
import difflib, pathlib, re, sys
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate")
BEFORE = OUT / "BACKUP_PKG_DMF0044_BODY_pre_editflagstd_20260810.sql"
AFTER = OUT / "PKG_DMF0044_BODY_EDITFLAGSTD_20260810.sql"

a = BEFORE.read_text(encoding="utf-8").splitlines()
b = AFTER.read_text(encoding="utf-8").splitlines()
print(f"[before] {BEFORE.name}  {len(a):,}행")
print(f"[after ] {AFTER.name}  {len(b):,}행   (+{len(b)-len(a)})\n")
print("=" * 116)
print("### EDITFLAGSTD 가 의도한 변경 (unified diff)")
print("=" * 116)
n = 0
for line in difflib.unified_diff(a, b, lineterm="", n=6):
    if line.startswith(("---", "+++")):
        continue
    print(line)
    n += 1
    if n > 220:
        print("... (이하 생략)")
        break
