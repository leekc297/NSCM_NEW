# -*- coding: utf-8 -*-
"""SCM_ADM_USER_MNU_EDIT_AUTH_V 정의·원천표·DMF0035 권한 행 실측 (읽기 전용)."""
import io
import re
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT TEXT FROM ALL_VIEWS
               WHERE OWNER='SCM_MGR' AND VIEW_NAME='SCM_ADM_USER_MNU_EDIT_AUTH_V'""")
row = cur.fetchone()
txt = row[0].read() if row and hasattr(row[0], "read") else (row[0] if row else "")
out = r"C:\Projects\NSCM\_artifacts\_apply_corporate\DMF0035_TUNING_20260820\EDIT_AUTH_V_DDL.sql"
open(out, "w", encoding="utf-8").write(txt or "")
print(f"[saved] {out} ({len(txt or '')} chars)")
print("== 원천 테이블 ==")
for t in sorted(set(re.findall(r"(?:FROM|JOIN)\s+(?:SCM_MGR\.)?([A-Z_][A-Z0-9_]+)", (txt or "").upper()))):
    print("  ", t)

print("\n== DMF0035 권한 행 (사내) ==")
cur.execute("""SELECT UNIT_TP_CD, UNIT_ID, COUNT(*) CNT
               FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
               WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0035'
               GROUP BY UNIT_TP_CD, UNIT_ID ORDER BY 1,2""")
rows = cur.fetchall()
print(f"  {len(rows)} 조합" if rows else "  *** 0행 ***")
for r in rows[:12]:
    print("  ", r)

print("\n== 비교: DMF0044(정상 화면) 권한 행 ==")
cur.execute("""SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_MNU_EDIT_AUTH_V
               WHERE USER_ID='minyonglee1' AND MNU_ID='DMF0044'""")
print("  ", cur.fetchone()[0])
con.close()
