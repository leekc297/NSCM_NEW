# -*- coding: utf-8 -*-
"""DMF0003 씨앗 목록 + SSP_ANL_ESS_REQ 정체 (읽기 전용)"""
import sys, io, os
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

def q(title, sql, binds=None):
    print("=" * 100)
    print("### " + title)
    print("=" * 100)
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

# 0. 접속 정보
q("WHOAMI", "SELECT USER, SYS_CONTEXT('USERENV','DB_NAME') db, SYS_CONTEXT('USERENV','SERVER_HOST') host FROM DUAL")

# 1-a. MPG_M 컬럼 확인
q("SCM_ADM_MNU_BTN_MPG_M columns",
  "SELECT column_name, data_type FROM all_tab_columns WHERE table_name='SCM_ADM_MNU_BTN_MPG_M' ORDER BY column_id")
q("SCM_ADM_API_M columns",
  "SELECT column_name, data_type FROM all_tab_columns WHERE table_name='SCM_ADM_API_M' ORDER BY column_id")

con.close()
