#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DM_MST_ITEM_SINGLE_V 정의 원문 + 관련 객체 확인 (병목 근원 해부)"""
import sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info, fetch, show
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
con.call_timeout = 120000
cur = con.cursor()
cur.outputtypehandler = None

print("[1] 객체 정보")
show(*fetch(cur, """SELECT owner, object_name, object_type, status,
                           TO_CHAR(last_ddl_time,'YYYY-MM-DD HH24:MI') AS last_ddl
                      FROM all_objects
                     WHERE object_name IN ('DM_MST_ITEM_SINGLE_V','GT_DMF0044_ITEM_SINGLE_V','SCM_ITEM_M')
                     ORDER BY object_name"""))

print("\n[2] VIEW 원문")
cur.execute("SELECT text FROM all_views WHERE owner='SCM_MGR' AND view_name='DM_MST_ITEM_SINGLE_V'")
r = cur.fetchone()
if r:
    t = r[0].read() if hasattr(r[0], 'read') else r[0]
    pathlib.Path(r"C:\Projects\NSCM\_artifacts\_diagnostics\_tmp_DM_MST_ITEM_SINGLE_V.sql").write_text(t, encoding="utf-8")
    print(t)
else:
    print("(view not found)")

print("\n[3] SCM_ITEM_M 인덱스")
show(*fetch(cur, """SELECT i.index_name, i.uniqueness, i.num_rows, c.column_position, c.column_name
                      FROM all_indexes i JOIN all_ind_columns c
                        ON c.index_owner=i.owner AND c.index_name=i.index_name
                     WHERE i.table_owner='SCM_MGR' AND i.table_name='SCM_ITEM_M'
                     ORDER BY i.index_name, c.column_position"""))

print("\n[4] SCM_ITEM_M 통계")
show(*fetch(cur, """SELECT num_rows, blocks, TO_CHAR(last_analyzed,'YYYY-MM-DD HH24:MI') AS last_analyzed
                      FROM all_tables WHERE owner='SCM_MGR' AND table_name='SCM_ITEM_M'"""))

con.close()
