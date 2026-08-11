#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0044 TRANSFER 튜닝 — 사내 라이브 PKG_DMF0044 BODY 원문 dump (정본 확보)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

OUT = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_tmp_LIVE_PKG_DMF0044_BODY.sql")

u, p, d = conn_info()
with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()
    cur.execute("""SELECT text FROM all_source
                    WHERE owner='SCM_MGR' AND name='PKG_DMF0044' AND type='PACKAGE BODY'
                    ORDER BY line""")
    rows = cur.fetchall()
    txt = "".join(r[0] for r in rows)
    OUT.write_text(txt, encoding="utf-8")
    print(f"lines={len(rows)} bytes={len(txt)} -> {OUT}")
    cur.execute("""SELECT object_name, object_type, status, TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI:SS')
                     FROM all_objects WHERE owner='SCM_MGR' AND object_name='PKG_DMF0044'""")
    for r in cur.fetchall():
        print(r)
