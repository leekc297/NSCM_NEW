#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Transfer SQL ERROR 원문 추출 — SCM_SYS_LOG_BATCH / SCM_COM_SYS_LOG"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 180000
cur = con.cursor()

def sec(t): print("\n" + "=" * 118); print(t); print("=" * 118)

for tbl in ('SCM_SYS_LOG_BATCH', 'SCM_COM_SYS_LOG'):
    sec(f"[구조] {tbl}")
    show(*fetch(cur, """SELECT column_name, data_type FROM all_tab_columns
                         WHERE owner='SCM_MGR' AND table_name=:t ORDER BY column_id""", {"t": tbl}))

sec("[1] SCM_SYS_LOG_BATCH — 최근 40분")
try:
    show(*fetch(cur, """
    SELECT * FROM (
      SELECT TO_CHAR(EVENT_DATE,'HH24:MI:SS') t, PROGRAM_NAME, LOG_TYPE,
             SUBSTR(LOG_MESSAGE,1,300) msg, SUBSTR(DESCRIPTION,1,200) descr
        FROM SCM_MGR.SCM_SYS_LOG_BATCH
       WHERE EVENT_DATE > SYSDATE - 40/1440
       ORDER BY EVENT_DATE DESC) WHERE ROWNUM <= 40"""))
except Exception as e:
    print("  ", str(e)[:300])

sec("[2] SCM_COM_SYS_LOG — 최근 40분 (BE @SystemLog)")
try:
    cur.execute("""SELECT column_name FROM all_tab_columns
                    WHERE owner='SCM_MGR' AND table_name='SCM_COM_SYS_LOG'
                      AND (column_name LIKE '%DATE%' OR column_name LIKE '%TIME%')
                    ORDER BY column_id""")
    dcols = [r[0] for r in cur.fetchall()]
    dc = dcols[0] if dcols else 'CREATION_DATE'
    show(*fetch(cur, f"""
    SELECT * FROM (
      SELECT TO_CHAR({dc},'HH24:MI:SS') t, a.*
        FROM SCM_MGR.SCM_COM_SYS_LOG a
       WHERE {dc} > SYSDATE - 40/1440
       ORDER BY {dc} DESC) WHERE ROWNUM <= 15"""))
except Exception as e:
    print("  ", str(e)[:300])

con.close()
