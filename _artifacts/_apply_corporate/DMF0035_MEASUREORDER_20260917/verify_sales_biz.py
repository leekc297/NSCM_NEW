# -*- coding: utf-8 -*-
"""SALES(PKG_DMF0022) / BIZ(PKG_DMF0051) 의 v_OrderList 생성 재현 — MEASURE 포함 여부 판정."""
import sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

PROG = "DMF0035"
SHEETS = {"SALES(PKG_DMF0022)": "Sales Plan Waterfall",
          "BIZ  (PKG_DMF0051)": "Biz Plan Waterfall",
          "MKT  (PKG_DMF0035)": "Mkt Fcst Waterfall"}

NO_PERS = """
SELECT C.COLUMN_NAME, C.SORT_ORDER_NO
  FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID = :p AND C.SHEET_NAME = :s
   AND (C.DEFAULT_FLAG='Y'
        OR (C.VISIBLE_FLAG='N' AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y'))
 ORDER BY C.SORT_ORDER_NO
"""
PERS_USERS = """
SELECT DISTINCT USER_ID FROM SCM_MGR.SCM_MST_TITLESET_USER
 WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND USER_INQUIRY_COLUMN_TYPE_CODE='C' ORDER BY USER_ID
"""
PERS = """
SELECT C.COLUMN_NAME
  FROM SCM_MGR.SCM_MST_TITLESET_USER U
  INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
          ON U.PROGRAM_ID=C.PROGRAM_ID AND U.SHEET_NAME=C.SHEET_NAME AND U.COLUMN_NAME=C.COLUMN_NAME
         AND U.PROGRAM_ID=:p AND U.SHEET_NAME=:s AND U.USER_ID=:u
         AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
         AND (C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||:d||',')>0)
 UNION ALL
SELECT C.COLUMN_NAME FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
 WHERE C.PROGRAM_ID=:p AND C.SHEET_NAME=:s AND C.VISIBLE_FLAG='N'
   AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y'
"""

sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
with oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)) as db:
    cur = db.cursor()
    for label, sheet in SHEETS.items():
        print(f"\n===== {label} — '{sheet}' =====")
        cur.execute(NO_PERS, p=PROG, s=sheet)
        rows = cur.fetchall()
        cols = [r[0] for r in rows]
        mx = max((r[1] for r in rows), default=None)
        inc = "MEASURE" in cols
        print(f"  [개인화 없음] 컬럼 {len(cols)}개 · MEASURE 포함={inc} · 최대 SORT={mx}"
              f" · MEASURE SORT={dict(rows).get('MEASURE')}")
        print(f"     → ORDER BY 에 SORT_ORDER_NO 반영: {'O' if inc else 'X  ⚠ 결함'}")

        cur.execute(PERS_USERS, p=PROG, s=sheet)
        users = [r[0] for r in cur.fetchall()]
        if not users:
            print("  [개인화 'C'] 보유자 없음")
        for u in users:
            cur.execute(PERS, p=PROG, s=sheet, u=u, d="40")
            pc = [r[0] for r in cur.fetchall()]
            inc2 = "MEASURE" in pc
            print(f"  [개인화 'C'] {u:12s} 컬럼 {len(pc)}개 · MEASURE 포함={inc2}"
                  f" → {'O' if inc2 else 'X  ⚠ 결함'}")
