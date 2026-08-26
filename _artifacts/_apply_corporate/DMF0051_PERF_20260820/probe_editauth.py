# -*- coding: utf-8 -*-
"""SCM_ADM_USER_MNU_EDIT_AUTH_V 가 (USER_ID,MNU_ID,UNIT_ID) 당 몇 행인지 + QTY 증폭 실측."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def q(t, sql, binds=None):
    print(f"\n=== {t} ===")
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    print(" | ".join(cols))
    for r in cur.fetchall():
        print(" | ".join("" if x is None else str(x) for x in r))


q("EDIT_AUTH_V 행 (minyonglee1 / DMF0035)", """
SELECT * FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
 WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0035' ORDER BY UNIT_ID""")

q("UNIT_ID 별 행수 (=증폭 배수)", """
SELECT UNIT_ID, COUNT(*) CNT, COUNT(DISTINCT EDIT_YN) EDIT_NDV, MIN(EDIT_YN) MN, MAX(EDIT_YN) MX
  FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
 WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0035' GROUP BY UNIT_ID ORDER BY 1""")

q("타 사용자 표본 — 증폭 배수 분포 (DMF0035 메뉴)", """
SELECT CNT AS DUP_FACTOR, COUNT(*) AS USER_UNIT_PAIRS
  FROM (SELECT USER_ID, UNIT_ID, COUNT(*) CNT
          FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
         WHERE MNU_ID='DMF0035' GROUP BY USER_ID, UNIT_ID)
 GROUP BY CNT ORDER BY 1""")
con.close()
