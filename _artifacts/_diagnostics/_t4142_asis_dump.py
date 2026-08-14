#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""AS-IS SP 원문을 파일로 덤프 (콘솔 인코딩 회피)."""
import sys, os, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from asis import _conn

name = sys.argv[1]
out = pathlib.Path(sys.argv[2])
cn = _conn(); cur = cn.cursor()
cur.execute("SELECT m.definition FROM sys.sql_modules m WHERE m.object_id=OBJECT_ID(?)", name)
row = cur.fetchone()
cn.close()
if not row:
    print(f"NOT FOUND: {name}"); sys.exit(1)
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(row[0], encoding="utf-8")
print(f"[dump] {out} — {len(row[0])} chars, {row[0].count(chr(10))+1} lines")
