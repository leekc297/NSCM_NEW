# -*- coding: utf-8 -*-
"""SQL_ID 실행계획(액세스/필터 술어 포함) 덤프. 사용: python get_plan.py <sql_id> [child]"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

sid = sys.argv[1]
ch = int(sys.argv[2]) if len(sys.argv) > 2 else None
u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT PLAN_TABLE_OUTPUT FROM TABLE(
    DBMS_XPLAN.DISPLAY_CURSOR(:s, :c, 'ALLSTATS LAST +PREDICATE +COST'))""",
            {"s": sid, "c": ch})
for r in cur.fetchall():
    print(r[0])
con.close()
