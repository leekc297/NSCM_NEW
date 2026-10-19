# -*- coding: utf-8 -*-
"""
V_ORDER_LIST 생성 로직을 SP 와 동일하게 재현해 'C' 개인화 유무별 ORDER BY 를 확인.
적용 전/후 차이를 같은 입력으로 보여준다.
"""
import sys, pathlib, re
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb  # noqa: E402

PROG, SHEET = "DMF0035", "Mkt Fcst Waterfall"

# SP L2952~3038 과 동일 (개인화 유무 분기)
SQL_NO_PERS = """
SELECT LISTAGG(' ' || COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',', '')
         WITHIN GROUP (ORDER BY SORT_ORDER_NO)
  FROM (SELECT SORT_ORDER_NO, COLUMN_NAME, DATA_SORT_METHOD_CODE
          FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
         WHERE C.PROGRAM_ID = :p AND C.SHEET_NAME = :s
           AND (C.DEFAULT_FLAG='Y'
                OR (C.VISIBLE_FLAG='N' AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y')))
"""

SQL_PERS = """
SELECT LISTAGG(' ' || COLUMN_NAME || ' ' || DATA_SORT_METHOD_CODE || ',', '')
         WITHIN GROUP (ORDER BY SORT_ORDER_NO)
  FROM (
    SELECT CASE WHEN C.COLUMN_NAME='GROUP_ID' THEN NVL(TU.SORT_ORDER_NO,95)-0.5
                ELSE U.SORT_ORDER_NO END AS SORT_ORDER_NO
         , C.COLUMN_NAME, U.DATA_SORT_METHOD_CODE
      FROM SCM_MGR.SCM_MST_TITLESET_USER U
      INNER JOIN SCM_MGR.SCM_MST_SHEET_COLUMNS C
              ON U.PROGRAM_ID=C.PROGRAM_ID AND C.SHEET_NAME=:s AND U.COLUMN_NAME=C.COLUMN_NAME
             AND U.PROGRAM_ID=:p AND U.SHEET_NAME=:s AND U.USER_ID=:u
             AND U.USER_INQUIRY_COLUMN_TYPE_CODE='C'
             AND U.COLUMN_NAME NOT IN ('MEASURE')
             AND (C.DIVISION_ID IS NULL OR INSTR(','||C.DIVISION_ID||',', ','||:d||',')>0)
      LEFT OUTER JOIN SCM_MGR.SCM_MST_TITLESET_USER TU
             ON TU.PROGRAM_ID=C.PROGRAM_ID AND TU.SHEET_NAME=:s
            AND TU.USER_INQUIRY_COLUMN_TYPE_CODE='C' AND TU.COLUMN_NAME IN ('ITEM_ID')
            AND TU.USER_ID=:u
    UNION ALL
    SELECT C.SORT_ORDER_NO, C.COLUMN_NAME, C.DATA_SORT_METHOD_CODE
      FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
     WHERE C.PROGRAM_ID=:p AND C.SHEET_NAME=:s AND C.VISIBLE_FLAG='N'
       AND RTRIM(C.DEFAULT_FLAG,' -') IS NULL AND C.VALID_YN='Y' AND ROWNUM<=100)
"""


def guard(order_list, col_has_measure, fixed):
    """MEASURECOL 가드 재현. fixed=True 면 이번 패치 반영본."""
    if not col_has_measure and fixed:
        order_list = ("MEASURE ASC" if not order_list or not order_list.strip()
                      else order_list + ",MEASURE ASC")
    # VERSION_NO 가드는 생략(별건) / L3081~3082 REPLACE 규약
    out = re.sub(r"VERSION_NO", "VERSION_SORT DESC,VERSION_NO", order_list or "")
    out = re.sub(r"MEASURE", "SORT_ORDER_NO", out)
    return out


sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
with oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3)) as db:
    cur = db.cursor()

    cur.execute(SQL_NO_PERS, p=PROG, s=SHEET)
    ol = (cur.fetchone()[0] or "").rstrip(",")
    has = ",MEASURE," in ("," + ol.replace(" ", "") + ",").replace("ASC", "").replace("DESC", "")
    has = "MEASURE" in ol
    print("===== 개인화 없는 사용자 (SHEET_COLUMNS 경로) =====")
    print("  V_ORDER_LIST 원본 :", ol[-90:])
    print("  최종 ORDER BY 말미:", guard(ol, has, fixed=True)[-90:])
    print(f"  → SORT_ORDER_NO 포함: {'SORT_ORDER_NO' in guard(ol, has, True)}")

    cur.execute("SELECT DISTINCT USER_ID FROM SCM_MGR.SCM_MST_TITLESET_USER "
                "WHERE PROGRAM_ID=:p AND SHEET_NAME=:s AND USER_INQUIRY_COLUMN_TYPE_CODE='C' "
                "ORDER BY USER_ID", p=PROG, s=SHEET)
    users = [r[0] for r in cur.fetchall()]
    print(f"\n===== 'C' 개인화 사용자 {len(users)}명 (div 40) =====")
    for u in users:
        cur.execute(SQL_PERS, p=PROG, s=SHEET, u=u, d="40")
        ol = (cur.fetchone()[0] or "").rstrip(",")
        has = "MEASURE" in ol
        before = guard(ol, has, fixed=False)
        after = guard(ol, has, fixed=True)
        print(f"  {u:12s} MEASURE in 목록={has} | 적용전 SORT_ORDER_NO={'SORT_ORDER_NO' in before}"
              f" → 적용후={'SORT_ORDER_NO' in after}")
