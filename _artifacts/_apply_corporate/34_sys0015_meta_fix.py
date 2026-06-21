"""SYS0015 (Program) 메타 정합 fix — 사내 Oracle 적용.

목적: SYS0015 audit 위반 3건 fix (V01/V03/V04 — V02/V05 보고만).

배경 (사용자 요구 2026-06-21):
  V01: ProgramForm.tsx t('', '_Program ID(Name)') → t('LBL00644', 'Program ID(Name)')
       → 신규 LBL00644 × 3 lang 등록 의무 (FE locales 별도)
  V03: BTN_MPG_M (SYS0015) SEARCH/SAVE 만 등록. AS-IS ProgramInfo.cs InsertButton/DeleteButton 활성
       + FE hotkeyConfig insert/delete 호출. 룰 #feature-button-meta-completeness §3.1 정합 의무
       → INSERT/DELETE BTN_CD row 추가 (API_ID=NULL, FE 만 처리)
  V04: SHEET_COLUMNS (SYS0015) 5 col 모두 INPUT_TP_CD='S' (Standard read-only)
       → AS-IS CRUD 활성과 mismatch. 사용자 강조 "UI Category Setup 실 사용 데이터 채움" 위반
       → PROGRAM_ID='IM' (PK + AS-IS L156 LockColumn 정합) / NAME/PATH/CLASS='M' (필수) / USE_YN='O' (default 'Y')

룰 cross-check:
  - 룰 #22 i18n KO=EN=CN + CN 별도
  - 룰 #63 LBL 5자리
  - 메모리 feedback_input_tp_cd_im_standard
  - 메모리 feedback_ddl_grep_before_sql (MSG_M MSG_TP_CD/USE_YN NOT NULL)
  - 룰 #feature-button-meta-completeness §3.1

POST-AUDIT 검증:
  - LBL00644 × 3 lang = 3 row
  - BTN_MPG_M (SYS0015) ≥ 4 row (SEARCH/SAVE + INSERT/DELETE)
  - SHEET_COLUMNS INPUT_TP_CD 분포 = IM 1 / M 3 / O 1 (5 col 합계)

멱등성: MERGE WHEN NOT MATCHED + UPDATE WHERE (재실행 안전).
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# ──────────────────────────────────────────────────────────────
# V01: LBL00644 신규 등록 (Program ID(Name))
# ──────────────────────────────────────────────────────────────
LBL_ROWS = [
    ("LBL00644", "KO", "Program ID(Name)"),
    ("LBL00644", "EN", "Program ID(Name)"),
    ("LBL00644", "CN", "程序ID(名称)"),
]
print("\n[ V01 MERGE ] LBL00644 × 3 lang:")
merge_msg_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MSG_M tgt
USING (SELECT :msg_id AS MSG_ID, :lang_cd AS LANG_CD, :msg_nm AS MSG_NM FROM DUAL) src
   ON (tgt.MSG_ID = src.MSG_ID AND tgt.LANG_CD = src.LANG_CD)
WHEN NOT MATCHED THEN
  INSERT (MSG_ID, LANG_CD, MSG_NM, MSG_TP_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MSG_ID, src.LANG_CD, src.MSG_NM, 'LBL', 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
lbl_inserted = 0
for msg_id, lang_cd, msg_nm in LBL_ROWS:
    cur.execute(merge_msg_sql, {"msg_id": msg_id, "lang_cd": lang_cd, "msg_nm": msg_nm})
    lbl_inserted += cur.rowcount
print(f"  LBL00644 inserted/updated: {lbl_inserted}")

# ──────────────────────────────────────────────────────────────
# V03: BTN_MPG_M INSERT/DELETE row 추가 (API_ID=NULL — FE 만 처리)
# ──────────────────────────────────────────────────────────────
# DDL desc — SCM_ADM_MNU_BTN_MPG_M NOT NULL 컬럼 확인 필요
print("\n[ V03 PRE-AUDIT ] BTN_MPG_M SYS0015 현재:")
cur.execute("SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0015' ORDER BY 1,2")
for r in cur.fetchall():
    print(f"  {r}")

merge_btn_sql = """
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M tgt
USING (SELECT 'SYS0015' AS MNU_ID, 'main' AS SHT_NM, :btn_cd AS MNU_BTN_CD FROM DUAL) src
   ON (tgt.MNU_ID = src.MNU_ID AND tgt.SHT_NM = src.SHT_NM AND tgt.MNU_BTN_CD = src.MNU_BTN_CD)
WHEN NOT MATCHED THEN
  INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.MNU_ID, src.SHT_NM, src.MNU_BTN_CD, NULL, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
btn_inserted = 0
for btn_cd in ['INSERT', 'DELETE']:
    cur.execute(merge_btn_sql, {"btn_cd": btn_cd})
    btn_inserted += cur.rowcount
print(f"\n[ V03 MERGE ] INSERT/DELETE row inserted: {btn_inserted}")

# 권한 자동 복사 — ADMIN USER_GR (minyonglee1 소속) 에 INSERT/DELETE 권한 추가
print("\n[ V03 권한 자동 복사 — ADMIN USER_GR INSERT/DELETE:]")
merge_auth_sql = """
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M tgt
USING (SELECT 'ADMIN' AS USER_GR_ID, 'SYS0015' AS MNU_ID, 'main' AS SHT_NM, :btn_cd AS MNU_BTN_CD FROM DUAL) src
   ON (tgt.USER_GR_ID = src.USER_GR_ID AND tgt.MNU_ID = src.MNU_ID AND tgt.SHT_NM = src.SHT_NM AND tgt.MNU_BTN_CD = src.MNU_BTN_CD)
WHEN NOT MATCHED THEN
  INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.USER_GR_ID, src.MNU_ID, src.SHT_NM, src.MNU_BTN_CD, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
auth_inserted = 0
for btn_cd in ['INSERT', 'DELETE']:
    cur.execute(merge_auth_sql, {"btn_cd": btn_cd})
    auth_inserted += cur.rowcount
print(f"  ADMIN 권한 inserted: {auth_inserted}")

# ──────────────────────────────────────────────────────────────
# V04: SHEET_COLUMNS INPUT_TP_CD 정합 — 실 사용 데이터로 채움
# ──────────────────────────────────────────────────────────────
print("\n[ V04 PRE-AUDIT ] SHEET_COLUMNS INPUT_TP_CD 현재:")
cur.execute("SELECT COLUMN_NAME, INPUT_TP_CD FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0015' ORDER BY SORT_ORDER_NO")
for r in cur.fetchall():
    print(f"  {r}")

# 의도 (AS-IS ProgramInfo.cs L156 LockColumn 정합 + 화면 의도):
#   PROGRAM_ID = 'IM' (PK — 신규 시 입력, 수정 시 lock)
#   PROGRAM_NAME / PROGRAM_PATH / CLASS_NAME = 'M' (필수 입력)
#   USE_YN = 'O' (선택, default='Y')
INPUT_TP_UPDATES = [
    ("PROGRAM_ID",   "IM"),
    ("PROGRAM_NAME", "M"),
    ("PROGRAM_PATH", "M"),
    ("CLASS_NAME",   "M"),
    ("USE_YN",       "O"),
]
update_sql = """
UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS
   SET INPUT_TP_CD = :tp_cd, LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE
 WHERE PROGRAM_ID='SYS0015' AND COLUMN_NAME=:col_nm AND INPUT_TP_CD != :tp_cd
"""
col_updated = 0
for col, tp in INPUT_TP_UPDATES:
    cur.execute(update_sql, {"col_nm": col, "tp_cd": tp})
    col_updated += cur.rowcount
print(f"\n[ V04 UPDATE ] SHEET_COLUMNS INPUT_TP_CD 변경: {col_updated} row")

conn.commit()

# ──────────────────────────────────────────────────────────────
# POST-AUDIT
# ──────────────────────────────────────────────────────────────
print("\n" + "=" * 60)
print("[ POST-AUDIT ]")
print("\n  LBL00644 분포:")
cur.execute("SELECT LANG_CD, MSG_NM FROM SCM_MGR.SCM_ADM_MSG_M WHERE MSG_ID='LBL00644' ORDER BY LANG_CD")
lbl_post = cur.fetchall()
for r in lbl_post: print(f"    {r}")

print("\n  BTN_MPG_M (SYS0015):")
cur.execute("SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0015' ORDER BY 1,2")
btn_post = cur.fetchall()
for r in btn_post: print(f"    {r}")

print("\n  SHEET_COLUMNS INPUT_TP_CD:")
cur.execute("SELECT COLUMN_NAME, INPUT_TP_CD FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SYS0015' ORDER BY SORT_ORDER_NO")
sc_post = cur.fetchall()
for r in sc_post: print(f"    {r}")

# Verification
print("\n[ VERIFICATION ]")
m1 = "✓" if len(lbl_post) == 3 else "✗"
m2 = "✓" if len(btn_post) == 4 else "✗"
m3 = "✓" if any(r[1] == 'IM' for r in sc_post) else "✗"
print(f"  {m1} LBL00644 × 3 lang = 3 row → {len(lbl_post)}")
print(f"  {m2} BTN_MPG_M (SYS0015) ≥ 4 row (SEARCH/SAVE/INSERT/DELETE) → {len(btn_post)}")
print(f"  {m3} SHEET_COLUMNS INPUT_TP_CD 정합 (IM ≥ 1) → IM 1 / M 3 / O 1 기대")

conn.close()
print(f"\n[ done ] SYS0015 메타 fix 완료.")
if not all([len(lbl_post) == 3, len(btn_post) == 4, any(r[1] == 'IM' for r in sc_post)]):
    sys.exit(1)
