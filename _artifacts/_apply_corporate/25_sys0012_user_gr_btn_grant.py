"""SYS0012 USER_GR_MNU_BTN_MPG_M 권한 grant — 사내 Oracle 적용.

목적:
  사용자 보고: "Approve 버턴 실행 시 권한없음 메세지 나옴."
  → BE 권한 체크 (`@AuthCheck`) 가 `mnuBtnCd='APPROVE'` 의 USER_GR_MNU_BTN_MPG_M row 부재로 fail.
  SEARCH 는 작동 (조회 OK) → SEARCH 권한은 존재 / APPROVE/REJECT 만 누락.

배경:
  deploy artifact `SYS0012_v1_full/03_META/06_USER_GR_BTN.sql` 가 사내 미적용 또는
  부분 적용 (SEARCH 만 있고 APPROVE/REJECT 누락) 가능성.

원천 패턴 (DMF0072 100_btn_auth + SYS0011 06_USER_GR_BTN 동일):
  1. USER_GR_MNU_BTN_MPG_M = (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN='Y')
  2. GUEST 시드 (기본 권한)
  3. sister 자매 화면 (SYS0011 auth-request) 권한자 동적 복사

본 스크립트:
  - 사내 진단 (PRE-AUDIT 4 query)
  - 권한 row INSERT 3 BLOCK:
    B1. GUEST 시드 — main.SEARCH/APPROVE/REJECT 3 row
    B2. minyonglee1 USER_GR 시드 — 동일 3 row
    B3. sister 동적 복사 — SYS0011 SEARCH 권한자에게 SYS0012 3 row
  - POST-AUDIT (검증 query)

멱등성: NOT EXISTS 가드 (모든 INSERT 재실행 안전).
"""
import os, sys, time
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# PRE-AUDIT
print("\n[ PRE-AUDIT Q1 ] SCM_ADM_USER_GR_MNU_BTN_MPG_M (MNU_ID='SYS0012') 분포:")
cur.execute(
    "SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN "
    "FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY USER_GR_ID, MNU_BTN_CD"
)
pre = cur.fetchall()
if not pre:
    print("  ⚠ row 0 — deploy artifact 06_USER_GR_BTN.sql 미적용 확정")
else:
    for ugr, sht, btn, use in pre:
        print(f"  {ugr} / {sht} / {btn} / USE={use}")

print("\n[ PRE-AUDIT Q2 ] minyonglee1 의 USER_GR_ID 인벤토리:")
cur.execute(
    "SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M "
    "WHERE USER_ID='minyonglee1' ORDER BY USER_GR_ID"
)
my_grs = [r[0] for r in cur.fetchall()]
print(f"  minyonglee1 USER_GR_ID list: {my_grs}")

print("\n[ PRE-AUDIT Q3 ] SYS0011 (sister 화면) SEARCH 권한자 인벤토리:")
cur.execute(
    "SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0011' AND MNU_BTN_CD IN ('SEARCH','RETRIEVE') AND USE_YN='Y' "
    "ORDER BY USER_GR_ID"
)
sister_grs = [r[0] for r in cur.fetchall()]
print(f"  SYS0011 SEARCH 권한자 ({len(sister_grs)}): {sister_grs[:10]}{'...' if len(sister_grs) > 10 else ''}")

print("\n[ PRE-AUDIT Q4 ] BTN_MPG_M (SYS0012) — 권한 대상 BTN_CD 확인:")
cur.execute(
    "SELECT SHT_NM, MNU_BTN_CD FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY SHT_NM, MNU_BTN_CD"
)
btn_cds = cur.fetchall()
if not btn_cds:
    print("  ⚠ BTN_MPG_M 미적용 — 본 스크립트 진행 불가. 먼저 03_MNU_BTN_MPG.sql 적용 필요")
    conn.close()
    sys.exit(1)
else:
    for sht, btn in btn_cds:
        print(f"  {sht} / {btn}")

# INSERT BLOCK 1: GUEST 시드 (기본 3 BTN: SEARCH/APPROVE/REJECT)
print("\n[ INSERT B1 ] GUEST USER_GR 시드 (3 BTN_CD):")
b1_sql = """
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT 'GUEST', 'SYS0012', 'main', NEW.BTN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT 'SEARCH'  AS BTN FROM DUAL UNION ALL
        SELECT 'APPROVE'        FROM DUAL UNION ALL
        SELECT 'REJECT'         FROM DUAL) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID='GUEST' AND X.MNU_ID='SYS0012' AND X.SHT_NM='main' AND X.MNU_BTN_CD = NEW.BTN
 )
"""
t0 = time.time()
cur.execute(b1_sql)
b1_inserted = cur.rowcount
print(f"  {b1_inserted} row inserted ({time.time()-t0:.2f}s)")

# INSERT BLOCK 2: minyonglee1 USER_GR 시드
print("\n[ INSERT B2 ] minyonglee1 USER_GR 시드 (3 BTN_CD × N user_gr):")
b2_sql = """
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'SYS0012', 'main', NEW.BTN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID='minyonglee1') u
 CROSS JOIN (SELECT 'SEARCH'  AS BTN FROM DUAL UNION ALL
             SELECT 'APPROVE'        FROM DUAL UNION ALL
             SELECT 'REJECT'         FROM DUAL) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = u.USER_GR_ID AND X.MNU_ID='SYS0012' AND X.SHT_NM='main' AND X.MNU_BTN_CD = NEW.BTN
 )
"""
t0 = time.time()
cur.execute(b2_sql)
b2_inserted = cur.rowcount
print(f"  {b2_inserted} row inserted ({time.time()-t0:.2f}s)")

# INSERT BLOCK 3: sister 동적 복사 (SYS0011 SEARCH 권한자)
print("\n[ INSERT B3 ] sister (SYS0011 SEARCH 권한자) 동적 복사 (3 BTN_CD × N user_gr):")
b3_sql = """
INSERT INTO SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
  (USER_GR_ID, MNU_ID, SHT_NM, MNU_BTN_CD, USE_YN, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
SELECT DISTINCT u.USER_GR_ID, 'SYS0012', 'main', NEW.BTN, 'Y', 'admin', SYSDATE, 'admin', SYSDATE
  FROM (SELECT DISTINCT USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M
         WHERE MNU_ID='SYS0011' AND MNU_BTN_CD IN ('SEARCH','RETRIEVE') AND USE_YN='Y') u
 CROSS JOIN (SELECT 'SEARCH'  AS BTN FROM DUAL UNION ALL
             SELECT 'APPROVE'        FROM DUAL UNION ALL
             SELECT 'REJECT'         FROM DUAL) NEW
 WHERE NOT EXISTS (
   SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M X
    WHERE X.USER_GR_ID = u.USER_GR_ID AND X.MNU_ID='SYS0012' AND X.SHT_NM='main' AND X.MNU_BTN_CD = NEW.BTN
 )
"""
t0 = time.time()
cur.execute(b3_sql)
b3_inserted = cur.rowcount
print(f"  {b3_inserted} row inserted ({time.time()-t0:.2f}s)")

conn.commit()
total = b1_inserted + b2_inserted + b3_inserted
print(f"\n  COMMIT done — 총 {total} row (B1 {b1_inserted} / B2 {b2_inserted} / B3 {b3_inserted})")

# POST-AUDIT
print("\n[ POST-AUDIT ] SCM_ADM_USER_GR_MNU_BTN_MPG_M (MNU_ID='SYS0012') 분포:")
cur.execute(
    "SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN "
    "FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY USER_GR_ID, MNU_BTN_CD"
)
post = cur.fetchall()
for ugr, sht, btn, use in post:
    print(f"  {ugr} / {sht} / {btn} / USE={use}")

# 검증
print("\n[ VERIFICATION ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' AND MNU_BTN_CD='APPROVE' AND USE_YN='Y'"
)
approve_ugr_cnt = cur.fetchone()[0]
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' AND MNU_BTN_CD='REJECT' AND USE_YN='Y'"
)
reject_ugr_cnt = cur.fetchone()[0]
m1 = "✓" if approve_ugr_cnt > 0 else "✗"
m2 = "✓" if reject_ugr_cnt > 0 else "✗"
print(f"  {m1} APPROVE 권한 USER_GR: {approve_ugr_cnt}")
print(f"  {m2} REJECT  권한 USER_GR: {reject_ugr_cnt}")

# minyonglee1 의 APPROVE 매칭 확인
print("\n[ minyonglee1 권한 cross-check ]")
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B "
    "JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M U ON U.USER_GR_ID = B.USER_GR_ID "
    "WHERE U.USER_ID='minyonglee1' AND B.MNU_ID='SYS0012' "
    "  AND B.MNU_BTN_CD='APPROVE' AND B.USE_YN='Y'"
)
my_approve = cur.fetchone()[0]
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B "
    "JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M U ON U.USER_GR_ID = B.USER_GR_ID "
    "WHERE U.USER_ID='minyonglee1' AND B.MNU_ID='SYS0012' "
    "  AND B.MNU_BTN_CD='REJECT' AND B.USE_YN='Y'"
)
my_reject = cur.fetchone()[0]
mm1 = "✓" if my_approve > 0 else "✗"
mm2 = "✓" if my_reject > 0 else "✗"
print(f"  {mm1} minyonglee1 APPROVE 매칭: {my_approve}")
print(f"  {mm2} minyonglee1 REJECT  매칭: {my_reject}")

conn.close()
print(f"\n[ done ] SYS0012 USER_GR_BTN 권한 grant 완료 ({total} row).")
print("  ⚠ BE 권한 캐시 갱신 위해 BE 재시작 또는 캐시 invalidate 필요할 수 있음.")
if my_approve == 0 or my_reject == 0:
    print("⚠ minyonglee1 권한 매칭 0 — 추가 진단 필요")
    sys.exit(1)
