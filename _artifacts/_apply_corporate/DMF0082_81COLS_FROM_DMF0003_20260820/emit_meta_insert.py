# -*- coding: utf-8 -*-
"""사내 적재된 4컬럼 행을 클라우드 패키지 INSERT 문으로 에미트 (원장 실측 승계 — 손작성 금지)."""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("""SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR'
               AND TABLE_NAME='SCM_MST_SHEET_COLUMNS' ORDER BY COLUMN_ID""")
cols = [r[0] for r in cur.fetchall()]
cur.execute(f"""SELECT {','.join(cols)} FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'
                AND COLUMN_NAME IN ('DEPT_ID','DEPT_NAME_KO','DEPT_NAME','GROUP_ID')
                ORDER BY SORT_ORDER_NO""")
rows = cur.fetchall()
types = {c[0]: c[1] for c in cur.description}


def lit(name, v):
    if v is None:
        return "NULL"
    if isinstance(v, (int, float)):
        return str(v)
    if hasattr(v, "strftime"):
        return f"TO_DATE('{v:%Y%m%d%H%M%S}','YYYYMMDDHH24MISS')"
    return "'" + str(v).replace("'", "''") + "'"


out = ["-- [E20260820-DMF0003COLS] DMF0003 'Mkt Fcst' 81축 결손 4컬럼 이식 (사용자 선택 2026-08-20)",
       "--   AS-IS 원값 승계 · 숨김('N')+사용자선택('Y') · 사내 적용 완료분 실측 에미트",
       "DELETE FROM SCM_MGR.SCM_MST_SHEET_COLUMNS",
       " WHERE PROGRAM_ID='DMF0082' AND SHEET_NAME='FcstNPrice'",
       "   AND COLUMN_NAME IN ('DEPT_ID','DEPT_NAME_KO','DEPT_NAME','GROUP_ID');", ""]
for r in rows:
    vals = ", ".join(lit(cols[i], v) for i, v in enumerate(r))
    out.append(f"INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS ({', '.join(cols)})")
    out.append(f"VALUES ({vals});")
out.append("COMMIT;")
txt = "\n".join(out) + "\n"
dst = r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260820\A_DB\06_SHEET_COLUMNS_81_DMF0003COLS_20260820.sql"
open(dst, "w", encoding="utf-8").write(txt)
print(f"[emit] {dst} ({len(rows)} rows, {len(cols)} cols)")
con.close()
