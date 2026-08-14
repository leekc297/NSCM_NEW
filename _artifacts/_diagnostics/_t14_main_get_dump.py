#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""PKG_DMF0014 메인 GET 본문 덤프 (Excel Form SP 의 FROM/WHERE 재사용 근거 확보)."""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

OUT = pathlib.Path(sys.argv[1]) if len(sys.argv) > 1 else pathlib.Path("_t14_body.sql")
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT LINE, TEXT FROM ALL_SOURCE
               WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0014' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
rows = cur.fetchall()
OUT.write_text("".join(r[1] for r in rows), encoding="utf-8")
print(f"[dump] {OUT} — {len(rows)} lines")

# 메인 GET 프로시저 시작/끝 라인 추정
start = end = None
for ln, tx in rows:
    up = (tx or "").upper()
    if "PROCEDURE P_DMF0014_GET_CUST_FCST_UPLOAD_DATA" in up:
        start = ln
    if start and "END P_DMF0014_GET_CUST_FCST_UPLOAD_DATA" in up:
        end = ln
        break
print(f"[range] P_DMF0014_GET_CUST_FCST_UPLOAD_DATA = L{start} ~ L{end}")
con.close()
