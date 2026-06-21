"""SYS0013 Execute 버튼 권한 grant — 사내 Oracle 적용.

목적:
  사용자 보고: "customButtons['Execute'] 버튼이 보이지 않습니다."
  → 사내 직접 query 결과 확정:
    - SCM_ADM_MNU_BTN_MPG_M (SYS0013, result, EXECUTE) ✓ 등록
    - SCM_ADM_USER_GR_MNU_BTN_MPG_M (ADMIN, SYS0013, result, EXECUTE) ❌ 부재
    → BE PR_CHECK_MNU_BTN_AUTH('minyonglee1','SYS0013','result','EXECUTE')='N'
    → FE hasButton('EXECUTE')=false → 빈 customButtons → 버튼 숨김.

배경 (SYS0012 25_*.py 권한 grant 패턴 정합):
  3 BLOCK MERGE:
    B1. GUEST 시드 — result.EXECUTE
    B2. minyonglee1 의 모든 USER_GR (CROSS JOIN USER_GR_MPG_M)
    B3. sister 자동 복사 — SYS0013 의 main.SEARCH 권한자 동일 USER_GR

룰 cross-check:
  - 룰 #feature-button-meta-completeness §3.2 — GUEST + sister 자동 복사 의무
  - 메모리 feedback_ddl_grep_before_sql — USE_YN NOT NULL 정합

멱등성: MERGE WHEN NOT MATCHED (재실행 안전).
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# PRE-AUDIT
print("\n[ PRE-AUDIT Q1 ] SYS0013 result.EXECUTE 현재 권한 분포:")
cur.execute(
    "SELECT USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0013' AND SHT_NM='result' AND MNU_BTN_CD='EXECUTE' "
    "ORDER BY USER_GR_ID"
)
pre = cur.fetchall()
if not pre:
    print("  (없음 — 신규 등록)")
else:
    for r in pre:
        print(f"  {r}")

print("\n[ PRE-AUDIT Q2 ] minyonglee1 USER_GR 인벤토리:")
cur.execute(
    "SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M "
    "WHERE USER_ID='minyonglee1' ORDER BY USER_GR_ID"
)
my_grs = [r[0] for r in cur.fetchall()]
print(f"  minyonglee1 USER_GR: {my_grs}")

print("\n[ PRE-AUDIT Q3 ] SYS0013 main.SEARCH 권한자 (sister 시드 원천):")
cur.execute(
    "SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0013' AND SHT_NM='main' AND MNU_BTN_CD='SEARCH' AND USE_YN='Y' "
    "ORDER BY USER_GR_ID"
)
sister_grs = [r[0] for r in cur.fetchall()]
print(f"  SYS0013 main.SEARCH 권한자 ({len(sister_grs)}): {sister_grs[:10]}{'...' if len(sister_grs) > 10 else ''}")

# BLOCK 1: GUEST 시드
print("\n[ INSERT B1 ] GUEST 시드 (result.EXECUTE):")
b1_sql = """
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M tgt
USING (SELECT 'GUEST' AS USER_GR_ID, 'SYS0013' AS MNU_ID, 'result' AS SHT_NM, 'EXECUTE' AS MNU_BTN_CD FROM DUAL) src
   ON (tgt.USER_GR_ID = src.USER_GR_ID AND tgt.MNU_ID = src.MNU_ID
       AND tgt.SHT_NM = src.SHT_NM AND tgt.MNU_BTN_CD = src.MNU_BTN_CD)
WHEN NOT MATCHED THEN
  INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.USER_GR_ID, src.MNU_ID, src.SHT_NM, src.MNU_BTN_CD, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
cur.execute(b1_sql)
b1_inserted = cur.rowcount
print(f"  GUEST inserted: {b1_inserted}")

# BLOCK 2: minyonglee1 USER_GR 모두
print("\n[ INSERT B2 ] minyonglee1 USER_GR 동적 복사:")
b2_sql = """
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M tgt
USING (
  SELECT DISTINCT u.USER_GR_ID, 'SYS0013' AS MNU_ID, 'result' AS SHT_NM, 'EXECUTE' AS MNU_BTN_CD
    FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M u
   WHERE u.USER_ID='minyonglee1'
) src
   ON (tgt.USER_GR_ID = src.USER_GR_ID AND tgt.MNU_ID = src.MNU_ID
       AND tgt.SHT_NM = src.SHT_NM AND tgt.MNU_BTN_CD = src.MNU_BTN_CD)
WHEN NOT MATCHED THEN
  INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.USER_GR_ID, src.MNU_ID, src.SHT_NM, src.MNU_BTN_CD, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
cur.execute(b2_sql)
b2_inserted = cur.rowcount
print(f"  minyonglee1 USER_GR inserted: {b2_inserted}")

# BLOCK 3: sister 자동 복사 (SYS0013 main.SEARCH 권한자)
print("\n[ INSERT B3 ] sister 자동 복사 (SYS0013 main.SEARCH 권한자):")
b3_sql = """
MERGE INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M tgt
USING (
  SELECT DISTINCT u.USER_GR_ID, 'SYS0013' AS MNU_ID, 'result' AS SHT_NM, 'EXECUTE' AS MNU_BTN_CD
    FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M u
   WHERE u.MNU_ID='SYS0013' AND u.SHT_NM='main' AND u.MNU_BTN_CD='SEARCH' AND u.USE_YN='Y'
) src
   ON (tgt.USER_GR_ID = src.USER_GR_ID AND tgt.MNU_ID = src.MNU_ID
       AND tgt.SHT_NM = src.SHT_NM AND tgt.MNU_BTN_CD = src.MNU_BTN_CD)
WHEN NOT MATCHED THEN
  INSERT (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN,
          CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
  VALUES (src.USER_GR_ID, src.MNU_ID, src.SHT_NM, src.MNU_BTN_CD, 'Y',
          'admin', SYSDATE, 'admin', SYSDATE)
"""
cur.execute(b3_sql)
b3_inserted = cur.rowcount
print(f"  sister inserted: {b3_inserted}")

conn.commit()
total = b1_inserted + b2_inserted + b3_inserted
print(f"\n  COMMIT done — 총 {total} row (B1 {b1_inserted} / B2 {b2_inserted} / B3 {b3_inserted})")

# POST-AUDIT
print("\n[ POST-AUDIT ] SYS0013 result.EXECUTE 권한 분포:")
cur.execute(
    "SELECT USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0013' AND SHT_NM='result' AND MNU_BTN_CD='EXECUTE' "
    "ORDER BY USER_GR_ID"
)
post = cur.fetchall()
for r in post:
    print(f"  {r}")

print("\n[ minyonglee1 권한 cross-check ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B "
    "JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M U ON U.USER_GR_ID = B.USER_GR_ID "
    "WHERE U.USER_ID='minyonglee1' AND B.MNU_ID='SYS0013' "
    "  AND B.SHT_NM='result' AND B.MNU_BTN_CD='EXECUTE' AND B.USE_YN='Y'"
)
my_match = cur.fetchone()[0]
mark = "✓" if my_match > 0 else "✗"
print(f"  {mark} minyonglee1 result.EXECUTE 매칭: {my_match}")

conn.close()
print(f"\n[ done ] SYS0013 EXECUTE 권한 grant 완료 ({total} row).")
if my_match == 0:
    sys.exit(1)
