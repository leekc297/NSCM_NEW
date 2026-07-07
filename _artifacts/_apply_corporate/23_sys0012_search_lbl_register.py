"""SYS0012 조회조건 신규 LBL 4 키 × 3 lang = 12 row 등록 — 사내 Oracle 적용 (2026-06-28).

목적:
  SYS0012(Auth Approval) 조회조건 5종 표준 정비 — Div/User ID(Name)/Department/Request Date/Approval Result.
  - User ID(Name) = 기존 LBL00339 재사용(권위 DB 존재, 변경 없음).
  - Div/Department/Request Date/Approval Result = 신규(DB 최대 + FE 점유 회피 → LBL00675~678).

대상 (12 row, KO=EN / CN 별도):
  - LBL00675 / Div             / 部门
  - LBL00676 / Department      / 部署
  - LBL00677 / Request Date    / 申请日期
  - LBL00678 / Approval Result / 审批结果

룰: #22 KO=EN ✓ / #63 LBL 5자리 ✓ / NOT NULL 컬럼 MSG_TP_CD='LBL' + USE_YN='Y' 포함(과거 ORA-01400 교훈).
멱등: MERGE WHEN NOT MATCHED.
실행: NSCM_ORA_USER/PASS/DSN 환경변수 후 python 23_sys0012_search_lbl_register.py
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

LBL_ROWS = [
    ("LBL00675", "KO", "Div"),             ("LBL00675", "EN", "Div"),             ("LBL00675", "CN", "部门"),
    ("LBL00676", "KO", "Department"),       ("LBL00676", "EN", "Department"),       ("LBL00676", "CN", "部署"),
    ("LBL00677", "KO", "Request Date"),     ("LBL00677", "EN", "Request Date"),     ("LBL00677", "CN", "申请日期"),
    ("LBL00678", "KO", "Approval Result"),  ("LBL00678", "EN", "Approval Result"),  ("LBL00678", "CN", "审批结果"),
]

print("\n[ PRE-AUDIT ] LBL00675~678 기존 등록 점검:")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00675','LBL00676','LBL00677','LBL00678') ORDER BY MSG_ID, LANG_CD"
)
pre = cur.fetchall()
print("  (없음 — 신규 등록 안전)" if not pre else "  ⚠ 기존 존재:")
for m, l, n in pre:
    print(f"    {m} / {l} / {n}")

merge_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_TP_CD, MSG_NM, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, 'LBL', src.MSG_NM, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
print("\n[ MERGE ] LBL00675~678 × 3 lang = 12 row:")
inserted = 0
for msg_id, lang_cd, msg_nm in LBL_ROWS:
    cur.execute(merge_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm})
    if cur.rowcount > 0:
        inserted += 1
        print(f"  ✓ {msg_id} / {lang_cd} / {msg_nm}")
    else:
        print(f"  - {msg_id} / {lang_cd} / (이미 존재 — skip)")
conn.commit()
print(f"  COMMIT done — {inserted} inserted, {len(LBL_ROWS) - inserted} skipped")

print("\n[ POST-AUDIT ]")
cur.execute(
    "SELECT MSG_ID, LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M "
    "WHERE MSG_ID IN ('LBL00675','LBL00676','LBL00677','LBL00678') ORDER BY MSG_ID, LANG_CD"
)
post = cur.fetchall()
for m, l, n in post:
    print(f"  {m} / {l} / {n}")
mark = "✓" if len(post) == 12 else "✗"
print(f"\n[ VERIFICATION ] {mark} = 12 row → 실제 {len(post)} row")

conn.close()
if len(post) != 12:
    sys.exit(1)
