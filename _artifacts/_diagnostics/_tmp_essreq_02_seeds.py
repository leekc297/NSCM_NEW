# -*- coding: utf-8 -*-
"""DMF0003 씨앗 전수 + SSP_ANL_ESS_REQ 정체 (읽기 전용)"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

def q(title, sql, binds=None):
    print("=" * 110)
    print("### " + title)
    print("=" * 110)
    try:
        cur.execute(sql, binds or {})
        cols = [c[0] for c in cur.description]
        rows = cur.fetchall()
        print(" | ".join(cols))
        for r in rows:
            print(" | ".join("" if v is None else str(v) for v in r))
        print("(%d rows)" % len(rows))
        return rows
    except Exception as e:
        print("ERR:", e)
        return []
    finally:
        print()

q("owners of meta tables",
  "SELECT owner, table_name FROM all_tables WHERE table_name IN ('SCM_ADM_MNU_BTN_MPG_M','SCM_ADM_API_M') ORDER BY 1,2")

q("DMF0003 seeds (MPG_M x API_M)", """
SELECT m.SHT_NM, m.MNU_BTN_CD, m.API_ID, a.API_URL, a.API_TP_CD, m.USE_YN mpg_use, a.USE_YN api_use
  FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M m
  LEFT JOIN SCM_MGR.SCM_ADM_API_M a ON a.API_ID = m.API_ID
 WHERE m.MNU_ID = 'DMF0003'
 ORDER BY m.SHT_NM, m.MNU_BTN_CD
""")

q("SSP_ANL_ESS_REQ* objects (ALL_OBJECTS)", """
SELECT owner, object_name, object_type, status, TO_CHAR(created,'YYYY-MM-DD') created,
       TO_CHAR(last_ddl_time,'YYYY-MM-DD') last_ddl
  FROM ALL_OBJECTS
 WHERE object_name LIKE 'SSP_ANL_ESS_REQ%' OR object_name LIKE '%SSP_ANL_ESS_REQ%'
 ORDER BY owner, object_type, object_name
""")

q("PR_SSP_ANL_ESS_REQ / P_SSP_ANL_ESS_REQ objects", """
SELECT owner, object_name, object_type, status FROM ALL_OBJECTS
 WHERE object_name LIKE '%ANL_ESS_REQ%' ORDER BY 1,3,2
""")

con.close()
