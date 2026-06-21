#!/usr/bin/env python3
"""
DMF0043 메타 INSERT 직접 적용 — main + mainTitle + versionPopup + ratePopup sheet columns
환경변수: NSCM_ORA_USER / NSCM_ORA_PASS / NSCM_ORA_DSN
멱등: NOT EXISTS 패턴.
"""
import os, sys, oracledb

u = os.getenv("NSCM_ORA_USER")
p = os.getenv("NSCM_ORA_PASS")
d = os.getenv("NSCM_ORA_DSN")
if not (u and p and d):
    sys.exit("env NSCM_ORA_USER/PASS/DSN required")

# (sheet, col, label, sort, width, input_tp_cd, halign)
rows = [
    # main BASE 6 (FE ContributeMainGrid 의 BASE_COLUMNS 1:1)
    ('main', 'DEPARTMENT_NAME',    '부문',    1, 180, 'S', 'L'),
    ('main', 'DEPT_NAME',          '팀',      2, 200, 'S', 'L'),
    ('main', 'END_CUST_REPORT',    '고객군',  3, 120, 'S', 'L'),
    ('main', 'SOLDTO_CUST_REPORT', '판매처',  4, 140, 'S', 'L'),
    ('main', 'PRODUCT_GROUP',      '제품군',  5, 100, 'S', 'L'),
    ('main', 'DM_BIZ_TYPE',        '형태',    6,  80, 'S', 'L'),
    # versionPopup 5 (FE 원본 VersionPopup COLUMN_DEFS)
    ('versionPopup', 'VER_SEQ',     'Ver Seq', 1,  90, 'S', 'L'),
    ('versionPopup', 'YYYY',        'Year',    2,  90, 'M', 'L'),
    ('versionPopup', 'VERSION_NM',  '버전명',  3, 220, 'M', 'L'),
    ('versionPopup', 'VALID_YN',    '유효여부',4,  90, 'M', 'L'),
    ('versionPopup', 'DESCRIPTION', '설명',    5, 320, 'M', 'L'),
    # ratePopup 5 (FE 원본 ContributeRatePopup HTML table 헤더)
    ('ratePopup', 'DIVISION_ID',        'Division', 1, 100, 'S', 'L'),
    ('ratePopup', 'YYYYMM',             'YYYYMM',   2, 100, 'S', 'L'),
    ('ratePopup', 'OS_CORP_CD',         'OS Corp',  3, 100, 'S', 'L'),
    ('ratePopup', 'CONTRIBUTION_TYPE',  'Type',     4,  80, 'S', 'L'),
    ('ratePopup', 'CONTRIBUTION_RATIO', 'Ratio',    5,  80, 'S', 'R'),
]

# DDL NOT NULL 컬럼 모두 매핑 (PROGRAM_ID/SHEET_NAME/COLUMN_NAME/COLUMN_LABEL_NAME/
# SORT_ORDER_NO/FIXED_FLAG/COLUMN_WIDTH/HORIZONTAL_ALIGN_CODE/UPPERCASE_APPLY_FLAG/
# VISIBLE_FLAG/DEFAULT_FLAG/USER_SELECTABLE_FLAG/VALID_YN/CREATED_BY/LAST_UPDATED_BY/INPUT_TP_CD)
INSERT_SQL = """
INSERT INTO SCM_MGR.SCM_MST_SHEET_COLUMNS (
  PROGRAM_ID, SHEET_NAME, COLUMN_NAME,
  COLUMN_LABEL_NAME, SORT_ORDER_NO, COLUMN_WIDTH,
  VISIBLE_FLAG, FIXED_FLAG, UPPERCASE_APPLY_FLAG, USER_SELECTABLE_FLAG, DEFAULT_FLAG,
  VALID_YN,
  INPUT_TP_CD, HORIZONTAL_ALIGN_CODE,
  CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
)
SELECT 'DMF0043', :sheet, :col,
       :label, :sort, :width,
       'Y', 'N', 'N', 'Y', 'Y',
       'Y',
       :input_tp, :halign,
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_MST_SHEET_COLUMNS X
    WHERE X.PROGRAM_ID = 'DMF0043'
      AND X.SHEET_NAME = :sheet
      AND X.COLUMN_NAME = :col
 )
"""

# BLOCK 1: VERSION_MGMT button (BTN_MPG_M)
BTN_INSERT = """
INSERT INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M
  (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'DMF0043', 'main', 'VERSION_MGMT', 'P_DMF0043_VERSION_POPUP', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM DUAL
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M X
    WHERE X.MNU_ID = 'DMF0043' AND X.SHT_NM = 'main' AND X.MNU_BTN_CD = 'VERSION_MGMT'
 )
"""

# BLOCK 2: VERSION_MGMT 권한 동적 복사 (SEARCH 권한 그룹 → VERSION_MGMT)
GR_BTN_INSERT = """
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'DMF0043', 'main', 'VERSION_MGMT', 'Y',
       'admin', SYSDATE, 'admin', SYSDATE
  FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
 WHERE u.MNU_ID = 'DMF0043' AND u.SHT_NM = 'main' AND u.MNU_BTN_CD = 'SEARCH' AND u.USE_YN = 'Y'
   AND NOT EXISTS (
     SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M e
      WHERE e.USER_GR_ID = u.USER_GR_ID AND e.MNU_ID = 'DMF0043'
        AND e.SHT_NM = 'main' AND e.MNU_BTN_CD = 'VERSION_MGMT'
   )
"""

with oracledb.connect(user=u, password=p, dsn=d) as con:
    cur = con.cursor()

    print("=== AUDIT BEFORE ===")
    cur.execute("SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' GROUP BY SHEET_NAME ORDER BY SHEET_NAME")
    before = cur.fetchall()
    for r in before: print(f"  {r[0]:<20s} : {r[1]} rows")

    print("\n=== BLOCK 1: SHEET_COLUMNS INSERT (16 rows expected) ===")
    total = 0
    for (sheet, col, label, sort, width, input_tp, halign) in rows:
        cur.execute(INSERT_SQL, sheet=sheet, col=col, label=label, sort=sort, width=width, input_tp=input_tp, halign=halign)
        total += cur.rowcount
        print(f"  {sheet:<14s} {col:<22s} {label:<10s} inserted={cur.rowcount}")
    print(f"TOTAL inserted: {total}")

    print("\n=== BLOCK 2: BTN_MPG_M VERSION_MGMT INSERT ===")
    cur.execute(BTN_INSERT)
    print(f"  rows: {cur.rowcount}")

    print("\n=== BLOCK 3: USER_GR VERSION_MGMT 권한 복사 ===")
    cur.execute(GR_BTN_INSERT)
    print(f"  rows: {cur.rowcount}")

    con.commit()
    print("\n=== COMMIT done ===")

    print("\n=== AUDIT AFTER ===")
    cur.execute("SELECT SHEET_NAME, COUNT(*) FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' GROUP BY SHEET_NAME ORDER BY SHEET_NAME")
    for r in cur.fetchall(): print(f"  {r[0]:<20s} : {r[1]} rows")

    print("\n=== POST-AUDIT main sheet columns ===")
    cur.execute("SELECT COLUMN_NAME, SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD, VISIBLE_FLAG FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='main' ORDER BY SORT_ORDER_NO")
    for r in cur.fetchall(): print(f"  {r[1]:>2d} {r[0]:<22s} '{r[2]}' w={r[3]} tp={r[4]} vis={r[5]}")

    print("\n=== POST-AUDIT versionPopup sheet columns ===")
    cur.execute("SELECT COLUMN_NAME, SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='versionPopup' ORDER BY SORT_ORDER_NO")
    for r in cur.fetchall(): print(f"  {r[1]:>2d} {r[0]:<22s} '{r[2]}' w={r[3]} tp={r[4]}")

    print("\n=== POST-AUDIT ratePopup sheet columns ===")
    cur.execute("SELECT COLUMN_NAME, SORT_ORDER_NO, COLUMN_LABEL_NAME, COLUMN_WIDTH, INPUT_TP_CD FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='DMF0043' AND SHEET_NAME='ratePopup' ORDER BY SORT_ORDER_NO")
    for r in cur.fetchall(): print(f"  {r[1]:>2d} {r[0]:<22s} '{r[2]}' w={r[3]} tp={r[4]}")
