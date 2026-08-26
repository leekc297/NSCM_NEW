# -*- coding: utf-8 -*-
"""REQ:1ST-39-1 정정 — DMF0082 FcstNPrice CELL_PROD_SITE_ID DIVISION_ID 81 계열 회귀 제거.

사용자 확인: 2026-08-20 "미적용이 맞습니다" (통합테스트 1st No.39 — 81/81_JV Cell Prod Site 미조회+컬럼셋팅 제외).
정정: '40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG' → '40,82' (2026-08-11 확정값 복원).
"""
import io
import sys

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb
from ora import conn_info

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

KEY = dict(pg="DMF0082", sh="FcstNPrice", col="CELL_PROD_SITE_ID")
Q = ("SELECT DIVISION_ID, VISIBLE_FLAG, DEFAULT_FLAG, LAST_UPDATED_BY, "
     "TO_CHAR(LAST_UPDATE_DATE,'YYYYMMDD HH24:MI') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS "
     "WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND COLUMN_NAME=:col")

cur.execute(Q, KEY)
before = cur.fetchone()
print("[BEFORE]", before)
assert before and before[0] == "40,82,81,81_UC,81_HM,81_ST,81_HD,81_HG", f"전제 불일치 — 중단: {before}"

cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
               SET DIVISION_ID='40,82', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
               WHERE PROGRAM_ID=:pg AND SHEET_NAME=:sh AND COLUMN_NAME=:col""", KEY)
assert cur.rowcount == 1, f"영향 행수 {cur.rowcount} — 1 이어야 함"
con.commit()

cur.execute(Q, KEY)
print("[AFTER] ", cur.fetchone())
con.close()
print("[OK] REQ:1ST-39-1 사내 정정 완료 (1행)")
