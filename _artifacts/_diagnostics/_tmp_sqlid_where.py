# -*- coding: utf-8 -*-
"""현재 오래 도는 SQL_ID 가 어느 문장인지 (힌트 적용 여부 포함) 확인"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info  # noqa: E402
import oracledb  # noqa: E402

try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT SQL_ID, SUBSTR(SQL_TEXT,1,200), ROUND(ELAPSED_TIME/1e6) FROM V$SQL WHERE SQL_ID='fndp8c35xn8y5'")
for sid, txt, el in cur.fetchall():
    print("SQL_ID=%s  elapsed=%ss" % (sid, el))
    print(txt)
    print("  DYNAMIC_SAMPLING 포함:", "DYNAMIC_SAMPLING" in (txt or ""))
    print("  NO_PUSH_PRED 포함    :", "NO_PUSH_PRED" in (txt or ""))
print("\n== 라이브 플랜 상위 ==")
cur.execute("""SELECT PLAN_LINE_ID, LPAD(' ',PLAN_DEPTH)||PLAN_OPERATION||' '||NVL(PLAN_OPTIONS,''),
                      NVL(PLAN_OBJECT_NAME,''), PLAN_CARDINALITY, OUTPUT_ROWS
                 FROM V$SQL_PLAN_MONITOR WHERE SQL_ID='fndp8c35xn8y5' AND STATUS='EXECUTING'
                ORDER BY PLAN_LINE_ID FETCH FIRST 20 ROWS ONLY""")
for r in cur.fetchall():
    print("  %-3s %-42s %-28s est=%-8s act=%s" % r)
con.close()
