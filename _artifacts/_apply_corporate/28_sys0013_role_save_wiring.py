"""SYS0013 Role 저장 배선 — SYS0013_SAVE_USER_GROUP 를 generic call-proc 경로에 연결 (2026-06-28).

목적:
  View 탭 Role(다중선택 역할) 저장. AS-IS SCM0005 clbRole → SCM_ADM_DQ_USER_GROUP.
  BE(Java)/SP 무변경 — 기존 standalone SP `SYS0013_SAVE_USER_GROUP` 를 메타 배선만으로 호출.
  옵션 목록은 공용 콤보 UserGroup(배선 불요), 현재 역할은 main GET 의 GROUP_ID(이미 반환).

배선 3건 (멱등 MERGE):
  1. SCM_ADM_API_M     : API_SYS0013_SAVE_USER_GROUP (POST, API_URL=SYS0013_SAVE_USER_GROUP)
  2. SCM_ADM_MNU_BTN_MPG_M : (SYS0013, userGroup, SAVE) → 위 API
  3. SCM_ADM_PROC_M(SYS0013_SAVE_USER_GROUP): dqId/groupId/validYn/createdBy/lastUpdatedBy IN + o_rc1 OUT
     (camelCase = FE payload key, SORT_ORD = SP positional)

SP 시그니처(참조): P_DQ_ID, P_GROUP_ID, P_VALID_YN, P_CREATED_BY, P_LAST_UPDATED_BY, O_RC1.
실행: NSCM_ORA_USER/PASS/DSN 환경변수 후 python 28_sys0013_role_save_wiring.py
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)
u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

API_ID = "API_SYS0013_SAVE_USER_GROUP"
PROC = "SYS0013_SAVE_USER_GROUP"

# 1) API_M (API_MSG_ID 는 기존 SYS0013 SAVE 메시지 재사용)
cur.execute("""
MERGE INTO SCM_MGR.SCM_ADM_API_M t
USING (SELECT :api AS API_ID FROM DUAL) s ON (t.API_ID = s.API_ID)
WHEN NOT MATCHED THEN
  INSERT (API_ID, API_TP_CD, API_MSG_ID, API_MSG_DESC, API_URL, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (:api, 'POST', 'MSG_API_SYS0013_MAIN_SAVE', 'AS-IS: SCM_ADM_DQ_USER_GROUP role save',
          'SYS0013_SAVE_USER_GROUP', 'Y', 'admin', SYSDATE, 'admin', SYSDATE)
""", {"api": API_ID})
print(f"[1] API_M {API_ID}: {cur.rowcount} merged")

# 2) BTN_MPG_M (SYS0013, userGroup, SAVE)
cur.execute("""
MERGE INTO SCM_MGR.SCM_ADM_MNU_BTN_MPG_M t
USING (SELECT 'SYS0013' AS MNU_ID, 'userGroup' AS SHT_NM, 'SAVE' AS MNU_BTN_CD FROM DUAL) s
   ON (t.MNU_ID=s.MNU_ID AND t.SHT_NM=s.SHT_NM AND t.MNU_BTN_CD=s.MNU_BTN_CD)
WHEN MATCHED THEN UPDATE SET t.API_ID=:api, t.USE_YN='Y',
     t.LAST_UPDATED_BY='admin', t.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN
  INSERT (MNU_ID, SHT_NM, MNU_BTN_CD, API_ID, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES ('SYS0013', 'userGroup', 'SAVE', :api, 'Y', 'admin', SYSDATE, 'admin', SYSDATE)
""", {"api": API_ID})
print(f"[2] BTN_MPG_M userGroup.SAVE: {cur.rowcount} merged")

# 3) PROC_M (positional = SP signature)
PROC_ROWS = [
    ("dqId", "VARCHAR", "IN", 1),
    ("groupId", "VARCHAR", "IN", 2),
    ("validYn", "VARCHAR", "IN", 3),
    ("createdBy", "VARCHAR", "IN", 4),
    ("lastUpdatedBy", "VARCHAR", "IN", 5),
    ("o_rc1", "CURSOR", "OUT", 6),
]
merge_proc = """
MERGE INTO SCM_MGR.SCM_ADM_PROC_M t
USING (SELECT :pn AS PROC_NM, :cn AS COL_NM FROM DUAL) s
   ON (t.PROC_NM=s.PROC_NM AND t.COL_NM=s.COL_NM)
WHEN MATCHED THEN UPDATE SET t.DATA_TP_CD=:dt, t.COL_TP_CD=:ct, t.SORT_ORD=:so,
     t.LAST_UPDATED_BY='admin', t.LAST_UPDATE_DATE=SYSDATE
WHEN NOT MATCHED THEN
  INSERT (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (:pn, :cn, :dt, :ct, :so, 'admin', SYSDATE, 'admin', SYSDATE)
"""
for cn, dt, ct, so in PROC_ROWS:
    cur.execute(merge_proc, {"pn": PROC, "cn": cn, "dt": dt, "ct": ct, "so": so})
print(f"[3] PROC_M {PROC}: {len(PROC_ROWS)} rows merged")

conn.commit()

# 검증
print("\n[ VERIFY ]")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_API_M WHERE API_ID=:a", {"a": API_ID})
print(f"  API_M = {cur.fetchone()[0]} (기대 1)")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SYS0013' AND SHT_NM='userGroup' AND MNU_BTN_CD='SAVE'")
print(f"  BTN_MPG_M = {cur.fetchone()[0]} (기대 1)")
cur.execute("SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:p", {"p": PROC})
print(f"  PROC_M = {cur.fetchone()[0]} (기대 6)")
conn.close()
print("\n[ done ] SYS0013 Role 저장 배선 완료.")
