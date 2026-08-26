# -*- coding: utf-8 -*-
"""병목 문장 원문 저장 + 실행 플랜 (읽기 전용)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
sid = sys.argv[1] if len(sys.argv) > 1 else "amzyz3wfg59jk"
cur.execute("SELECT SQL_FULLTEXT FROM V$SQL WHERE SQL_ID=:s AND ROWNUM=1", {"s": sid})
row = cur.fetchone()
if row:
    t = row[0].read()
    out = rf"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_TUNING_20260820\bottleneck_{sid}.sql"
    open(out, "w", encoding="utf-8").write(t)
    print(f"[saved] {out} ({len(t)} chars)")
else:
    print("[warn] V$SQL 에 없음 (에이지 아웃)")
cur.execute("SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY_CURSOR(:s, NULL, 'BASIC +ROWS +COST'))", {"s": sid})
for r in cur.fetchall():
    print(r[0])
con.close()
