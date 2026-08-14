#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""통합테스트 No.41/42/64 — 사내 실측 probe.
  1) DMF0082 FCST_TYPE / END_CUSTOMER 셀 콤보 메타(등록 콤보 + ATTRIBUTE1~5 파라미터)
  2) 등재 콤보 SQL 을 토큰 치환 후 실행 (division × 사용자 조합)
"""
import sys, io, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()


def show(title, sql, binds=None):
    print("\n" + "=" * 110)
    print(f"## {title}")
    print("-" * 110)
    cur.execute(sql, binds or {})
    cols = [c[0] for c in cur.description]
    rows = cur.fetchall()
    print(" | ".join(cols))
    for r in rows:
        print(" | ".join("" if v is None else str(v) for v in r))
    print(f"({len(rows)} rows)")
    return rows


# 1) 셀 콤보 메타
show(
    "DMF0082 SHEET_COLUMNS — 콤보 배선 컬럼 (FCST_TYPE / END_CUSTOMER / SCM_SITE_ID)",
    """SELECT SHEET_NAME, COLUMN_NAME, DIVISION_ID, INPUT_TP_CD, VISIBLE_FLAG,
              CELL_CONTROL_OBJECT_TYPE_CODE CTRL, CELL_COMBO_DATA_TYPE COMBO,
              ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, VALID_YN
       FROM   SCM_MGR.SCM_MST_SHEET_COLUMNS
       WHERE  PROGRAM_ID = 'DMF0082'
       AND    COLUMN_NAME IN ('FCST_TYPE','END_CUSTOMER','SCM_SITE_ID','MEASURE','AS_FROM_SITE')
       ORDER BY SHEET_NAME, COLUMN_NAME""",
)

# 2) 콤보 실행 — FcstTypeByUserGroupDMF0082 (division 40 / 81 × W/S 사용자 / 비 W/S 사용자)
cur.execute(
    "SELECT SQL_DTL_CTN FROM SCM_MGR.SCM_ADM_CMBO_SQL_M WHERE SQL_ID='FcstTypeByUserGroupDMF0082'"
)
row = cur.fetchone()
base = row[0].read() if hasattr(row[0], "read") else row[0]

# W/S 그룹 보유자 / 미보유자 각각 1명 실측 확보
ws_users = show(
    "DM Planner (W/S) 그룹 보유 사용자 (상위 5)",
    """SELECT USER_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M
       WHERE USER_GR_ID = 'DM Planner (W/S)' AND USE_YN='Y'
       AND ROWNUM <= 5""",
)
ws_user = ws_users[0][0] if ws_users else "minyonglee1"

for div in ("40", "81", "-"):
    for uid, tag in ((ws_user, "W/S 보유"), ("minyonglee1", "minyonglee1")):
        sql = base.replace("@sesUserId", f"'{uid}'").replace("@divisionId", f"'{div}'")
        show(f"FcstTypeByUserGroupDMF0082 — division={div} / user={uid} ({tag})", sql)

con.close()
