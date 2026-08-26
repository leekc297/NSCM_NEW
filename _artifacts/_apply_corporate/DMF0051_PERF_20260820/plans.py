# -*- coding: utf-8 -*-
"""SQL_ID 별 FULLTEXT + 실행계획 덤프 (읽기 전용). 사용: python plans.py SQLID [SQLID...]"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
for sid in sys.argv[1:]:
    print("\n" + "=" * 110)
    print("SQL_ID", sid)
    print("=" * 110)
    cur.execute("SELECT SQL_FULLTEXT FROM V$SQL WHERE SQL_ID=:1 AND ROWNUM=1", [sid])
    r = cur.fetchone()
    if r:
        t = r[0]
        t = t.read() if hasattr(t, "read") else t
        print(t)
    print("-" * 110)
    cur.execute("SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:1, NULL, 'ALLSTATS LAST +OUTLINE'))", [sid])
    for (l,) in cur.fetchall():
        print(l)
con.close()
