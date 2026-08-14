#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""통합테스트 No.41/42 — 현재 사내 등재 CMBO 원문 덤프 (진단용)."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

IDS = sys.argv[1:] or ["FcstTypeByUserGroupDMF0082", "FcstType", "FcstTypeWs", "FcstTypeEditMode"]
u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    for sid in IDS:
        cur.execute(
            "SELECT SQL_ID, SQL_NM, SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID = :i",
            {"i": sid},
        )
        row = cur.fetchone()
        print("=" * 100)
        if not row:
            print(f"[{sid}] NOT FOUND")
            continue
        txt = row[2]
        if hasattr(txt, "read"):
            txt = txt.read()
        print(f"[{row[0]}] {row[1]}")
        print("-" * 100)
        print(txt)
