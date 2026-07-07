#!/usr/bin/env python3
"""DMF0003 전체점검 진단 D1~D4 (읽기전용 SELECT — 플랜 dmf0003-ui 승인분).

D1: SHEET_COLUMNS EDIT_FLAG/SORT_KEY/ITEM_NAME 등록 여부 (Yellow 미표시 S1 검증)
D2: EDIT_FLAG='Y' 데이터 조건 (MKT_FCST_MEASURE / GET_ADMIN_GROUP lookup + 사용자 DEPT)
D3: SenderCode 소스 lookup (EDI_SENDER_CODE)
D4: DMF0003 SHEET_COLUMNS 전체 인벤토리 (Model Name·감사용)
"""
import os

import oracledb

# 비밀번호는 파일에 하드코딩하지 않음 — 환경변수 NSCM_ORA_PW 로 주입 (레포 커밋 안전).
PW = os.environ.get("NSCM_ORA_PW")
if not PW:
    raise SystemExit("NSCM_ORA_PW env var required (SCM_MGR password)")

def connect():
    for kw in (dict(service_name="OCGSCMD_P01"), dict(sid="ESSCMD")):
        try:
            dsn = oracledb.makedsn(host="121.162.245.167", port=2521, **kw)
            c = oracledb.connect(user="SCM_MGR", password=PW, dsn=dsn)
            print(f"[CONN OK] {kw}")
            return c
        except Exception as e:
            print(f"[CONN FAIL] {kw} -> {e}")
    raise SystemExit(1)

conn = connect()
cur = conn.cursor()

def q(title, sql, binds=None):
    print(f"\n=== {title} ===")
    try:
        cur.execute(sql, binds or {})
        cols = [d[0] for d in cur.description]
        rows = cur.fetchall()
        print(" | ".join(cols))
        if not rows:
            print("  (0 rows)")
        for r in rows[:80]:
            print("  " + " | ".join(str(x) for x in r))
        if len(rows) > 80:
            print(f"  ... ({len(rows)} rows total)")
    except Exception as e:
        print(f"  [ERR] {e}")

# ---------- D1: EDIT_FLAG / SORT_KEY / ITEM_NAME 메타 등록 여부 ----------
q("D1a SHEET_COLUMNS (DMF0003 main: EDIT_FLAG/SORT_KEY/ITEM_NAME)",
  """SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DEFAULT_FLAG, DISPLAY_FLAG, VALID_YN, SORT_ORDER_NO
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE PROGRAM_ID='DMF0003' AND COLUMN_NAME IN ('EDIT_FLAG','SORT_KEY','ITEM_NAME')
      ORDER BY SHEET_NAME, COLUMN_NAME""")

q("D1b TITLESET_USER (minyonglee1 DMF0003 C-type)",
  """SELECT SHEET_NAME, COLUMN_NAME, COLUMN_TYPE, USER_FLAG
       FROM SCM_MGR.SCM_MST_TITLESET_USER
      WHERE PROGRAM_ID='DMF0003' AND USER_ID='minyonglee1'
      ORDER BY SHEET_NAME, SORT_ORDER_NO""")

# ---------- D2: EDIT_FLAG='Y' 조건 데이터 ----------
q("D2a LOOKUP MKT_FCST_MEASURE (SEGMENT5='Y' = 편집가능 메저)",
  """SELECT SEGMENT1 DIV, SEGMENT2 MEASURE, SEGMENT3, SEGMENT5, VALID_YN
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE LOOKUP_TYPE='MKT_FCST_MEASURE'
      ORDER BY SEGMENT1, SEGMENT2""")

q("D2b LOOKUP GET_ADMIN_GROUP",
  """SELECT SEGMENT1, SEGMENT2, VALID_YN FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' ORDER BY SEGMENT1""")

q("D2c 사용자 minyonglee1 DEPT/GROUP",
  """SELECT USER_ID, DEPT_ID, USER_GR_ID FROM
       (SELECT u.USER_ID, u.DEPT_ID, g.USER_GR_ID
          FROM SCM_MGR.SCM_ADM_USER_M u
          LEFT JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M g ON g.USER_ID=u.USER_ID
         WHERE u.USER_ID='minyonglee1')""")

# ---------- D3: SenderCode 소스 lookup ----------
q("D3a LOOKUP EDI_SENDER_CODE (SenderCode combo 소스 후보)",
  """SELECT SEGMENT1, SEGMENT2, SEGMENT3, VALID_YN
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE LOOKUP_TYPE='EDI_SENDER_CODE' ORDER BY SEGMENT1""")

q("D3b LOOKUP_TYPE 유사 후보 (SENDER 포함)",
  """SELECT DISTINCT LOOKUP_TYPE, COUNT(*) CNT
       FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
      WHERE UPPER(LOOKUP_TYPE) LIKE '%SENDER%' GROUP BY LOOKUP_TYPE""")

q("D3c CMBO_SQL_M SenderCode 등록 여부 (재확인)",
  """SELECT SQL_ID, SUBSTR(SQL_DTL_CTN,1,120) SQL_HEAD FROM SCM_MGR.SCM_ADM_CMBO_SQL_M
      WHERE UPPER(SQL_ID) LIKE '%SENDER%'""")

# ---------- D4: DMF0003 SHEET_COLUMNS 전체 인벤토리 ----------
q("D4 SHEET_COLUMNS 인벤토리 (DMF0003 전체 시트)",
  """SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, DEFAULT_FLAG, DISPLAY_FLAG, DIVISION_ID, SORT_ORDER_NO
       FROM SCM_MGR.SCM_MST_SHEET_COLUMNS
      WHERE PROGRAM_ID='DMF0003'
      ORDER BY SHEET_NAME, SORT_ORDER_NO""")

cur.close()
conn.close()
print("\n[DONE]")
