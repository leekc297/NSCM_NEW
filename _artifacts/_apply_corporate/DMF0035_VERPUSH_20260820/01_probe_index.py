# -*- coding: utf-8 -*-
"""세 원천표 인덱스 구조 실측 (읽기 전용) — VERSION_NO 가 선두 2번째 컬럼인지 확인."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

TBLS = ["DM_PLN_MKT_FCST_C", "DM_PLN_CFM_MKT_DEMAND_PLAN_C", "DM_PLN_MKT_FCST_RESULT_C", "GT_DM35_VERSION"]
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for t in TBLS:
    print(f"\n=== {t} ===")
    cur.execute("""SELECT I.INDEX_NAME, I.UNIQUENESS, I.PARTITIONED, I.NUM_ROWS, I.LAST_ANALYZED
                     FROM ALL_INDEXES I WHERE I.TABLE_OWNER='SCM_MGR' AND I.TABLE_NAME=:t ORDER BY 1""", {"t": t})
    for r in cur.fetchall():
        print("  IDX", r)
        cur2 = con.cursor()
        cur2.execute("""SELECT COLUMN_POSITION, COLUMN_NAME FROM ALL_IND_COLUMNS
                         WHERE INDEX_OWNER='SCM_MGR' AND INDEX_NAME=:n ORDER BY COLUMN_POSITION""", {"n": r[0]})
        print("      cols:", ", ".join(f"{a}:{b}" for a, b in cur2.fetchall()))
    cur.execute("""SELECT NUM_ROWS, LAST_ANALYZED, PARTITIONED FROM ALL_TABLES
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t""", {"t": t})
    print("  TAB stats:", cur.fetchall())
    # VERSION_NO 컬럼 존재 확인
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE FROM ALL_TAB_COLUMNS
                    WHERE OWNER='SCM_MGR' AND TABLE_NAME=:t AND COLUMN_NAME IN ('VERSION_NO','DIVISION_ID','CUTOFF_TYPE')
                    ORDER BY COLUMN_ID""", {"t": t})
    print("  key cols:", cur.fetchall())
con.close()
