#!/usr/bin/env python3
"""
DMF0043 main sheet 의 SMALL_CLASS_LABEL_NAME 을 COLUMN_LABEL_NAME 으로 UPDATE.
mapRawColumnsToWijmoColumns 의 getColumnDepth 가 TWO_DEPTH 로 판정 → 자동 nested 변환
→ 좌측 BASE column 도 height=24 적용 → 우측 다단과 정합 (좌측 단단 유지).
"""
import os, sys, oracledb

u = os.getenv("NSCM_ORA_USER")
p = os.getenv("NSCM_ORA_PASS")
d = os.getenv("NSCM_ORA_DSN")
if not (u and p and d): sys.exit("env NSCM_ORA_USER/PASS/DSN required")

with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()

    print("=== BEFORE ===")
    cur.execute("""SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='main'
                    ORDER BY SORT_ORDER_NO""")
    for r in cur.fetchall():
        print(f"  {r[0]:<22s} lbl='{r[1]}' sCls='{r[2] or ''}' lCls='{r[3] or ''}'")

    print("\n=== UPDATE SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME ===")
    cur.execute("""UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
                      SET SMALL_CLASS_LABEL_NAME = COLUMN_LABEL_NAME
                    WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='main'
                      AND (SMALL_CLASS_LABEL_NAME IS NULL OR SMALL_CLASS_LABEL_NAME = '')""")
    print(f"  rows updated: {cur.rowcount}")
    con.commit()

    print("\n=== AFTER ===")
    cur.execute("""SELECT COLUMN_NAME, COLUMN_LABEL_NAME, SMALL_CLASS_LABEL_NAME, LARGE_CLASS_LABEL_NAME
                     FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
                    WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='main'
                    ORDER BY SORT_ORDER_NO""")
    for r in cur.fetchall():
        print(f"  {r[0]:<22s} lbl='{r[1]}' sCls='{r[2] or ''}' lCls='{r[3] or ''}'")
