"""SYS0012 권한 체크 (PR_CHECK_MNU_BTN_AUTH) 직접 trace — 사내 Oracle (read-only).

목적:
  사용자 보고: "Approve 클릭 시 권한없음 메세지 나옵니다."
  → 25_sys0012_user_gr_btn_grant.py 실행 후에도 권한없음 (또는 실행 안 됨).
  BE 권한 흐름:
    URL /SYS0012/main/APPROVE/call-proc
    → CustomAuthorizationManager._authorize() (segments parse)
    → AuthServiceImpl.checkMenuBtnAuth(userId='minyonglee1','SYS0012','main','APPROVE')
    → SP PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH
    → cursor 의 HAS_AUTH_YN = 'Y' 면 통과

본 스크립트 (read-only):
  Q1. 25 스크립트 실행 후 상태 확인 (USER_GR_BTN_MPG_M minyonglee1 매칭)
  Q2. 권한 SP body read — 조회 대상 테이블 확인 (SCM_ADM_USER_GR_MNU_BTN_MPG_M 외 다른 테이블?)
  Q3. 직접 SP 호출 (minyonglee1, SYS0012, main, APPROVE) — HAS_AUTH_YN 결과 확인
  Q4. minyonglee1 의 SCM_ADM_USER_M / USER_GR_MPG_M / USER_GR_MNU_BTN_MPG_M 풀 조인 trace

진단 가설:
  A. 25 미실행 → Q1 row 0
  B. 25 실행됐으나 BE 캐시 stale → Q3 SP 직접 호출 = 'Y' (BE 만 'N')
  C. 권한 SP 가 BTN_CD 표준만 인식 → Q3 'N' + Q2 body 의 BTN_CD 매칭 logic 확인
  D. BTN_MPG_M 의 사내 적용 미완 (USE_YN='N' 등) → Q1 OK 지만 Q3 'N'
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")

# Q1. minyonglee1 의 SYS0012 권한 분포
print("\n[ Q1 ] minyonglee1 의 SYS0012 권한 매칭 (USER_GR_MPG_M JOIN USER_GR_MNU_BTN_MPG_M):")
cur.execute(
    "SELECT B.USER_GR_ID, B.MNU_BTN_CD, B.USE_YN "
    "FROM SCM_MGR.SCM_ADM_USER_GR_MNU_BTN_MPG_M B "
    "JOIN SCM_MGR.SCM_ADM_USER_GR_MPG_M U ON U.USER_GR_ID = B.USER_GR_ID "
    "WHERE U.USER_ID='minyonglee1' AND B.MNU_ID='SYS0012' "
    "ORDER BY B.MNU_BTN_CD"
)
q1 = cur.fetchall()
if not q1:
    print("  ⚠ row 0 — 25 스크립트 미실행 또는 minyonglee1 USER_GR 부재 (가설 A)")
else:
    for ugr, btn, use in q1:
        print(f"  {ugr} / {btn} / USE={use}")

# Q2. PR_CHECK_MNU_BTN_AUTH SP body 발췌
print("\n[ Q2 ] PR_CHECK_MNU_BTN_AUTH SP body (조회 대상 테이블 + WHERE 절):")
cur.execute(
    "SELECT LINE, TEXT FROM ALL_SOURCE "
    "WHERE NAME = 'PKG_NSCM_UI_COM_AUTH' AND TYPE = 'PACKAGE BODY' "
    "  AND UPPER(TEXT) LIKE '%CHECK_MNU_BTN_AUTH%' "
    "ORDER BY LINE"
)
header = cur.fetchall()
if not header:
    print("  ⚠ PR_CHECK_MNU_BTN_AUTH 찾을 수 없음")
else:
    # body 시작 line 찾기
    start_line = header[0][0]
    cur.execute(
        "SELECT LINE, TEXT FROM ALL_SOURCE "
        "WHERE NAME = 'PKG_NSCM_UI_COM_AUTH' AND TYPE = 'PACKAGE BODY' "
        "  AND LINE BETWEEN :s AND :e "
        "ORDER BY LINE",
        {"s": start_line, "e": start_line + 80}
    )
    for ln, txt in cur.fetchall():
        text = str(txt).rstrip()
        marker = ""
        if "USER_GR_MNU_BTN_MPG_M" in text.upper():
            marker = " ← USER_GR_MNU_BTN_MPG_M"
        elif "USER_GR_MPG_M" in text.upper():
            marker = " ← USER_GR_MPG_M (사용자→그룹)"
        elif "MNU_BTN_MPG_M" in text.upper() and "USER_GR" not in text.upper():
            marker = " ← MNU_BTN_MPG_M (메뉴→버튼)"
        elif "HAS_AUTH_YN" in text.upper():
            marker = " ← HAS_AUTH_YN 결정 line"
        print(f"  L{ln}: {text}{marker}")

# Q3. 직접 SP 호출 — APPROVE 권한 체크
print("\n[ Q3 ] 직접 SP 호출 — PR_CHECK_MNU_BTN_AUTH('minyonglee1','SYS0012','main','APPROVE'):")
try:
    out_cursor = cur.var(oracledb.CURSOR)
    cur.callproc(
        "SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH",
        ['minyonglee1', 'SYS0012', 'main', 'APPROVE', out_cursor]
    )
    result_cursor = out_cursor.getvalue()
    rows = result_cursor.fetchall()
    cols = [d[0] for d in result_cursor.description]
    print(f"  결과 컬럼: {cols}")
    for r in rows:
        print(f"  값: {dict(zip(cols, r))}")
    if not rows:
        print("  ⚠ 결과 row 0 — 권한 없음 (HAS_AUTH_YN 'N' 동등)")
    else:
        has_auth = rows[0][cols.index('HAS_AUTH_YN')] if 'HAS_AUTH_YN' in cols else None
        mark = "✓" if has_auth == 'Y' else "✗"
        print(f"  {mark} HAS_AUTH_YN = '{has_auth}' (기대 'Y')")
except Exception as e:
    print(f"  ⚠ SP 호출 실패: {e}")

# REJECT 도 동일
print("\n[ Q3-2 ] 직접 SP 호출 — REJECT:")
try:
    out_cursor = cur.var(oracledb.CURSOR)
    cur.callproc(
        "SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH",
        ['minyonglee1', 'SYS0012', 'main', 'REJECT', out_cursor]
    )
    result_cursor = out_cursor.getvalue()
    rows = result_cursor.fetchall()
    cols = [d[0] for d in result_cursor.description]
    for r in rows:
        print(f"  {dict(zip(cols, r))}")
    if not rows:
        print("  ⚠ row 0")
except Exception as e:
    print(f"  ⚠ SP 호출 실패: {e}")

# SEARCH 도 (작동했다는 baseline)
print("\n[ Q3-3 ] 직접 SP 호출 — SEARCH (baseline — 작동 확인):")
try:
    out_cursor = cur.var(oracledb.CURSOR)
    cur.callproc(
        "SCM_MGR.PKG_NSCM_UI_COM_AUTH.PR_CHECK_MNU_BTN_AUTH",
        ['minyonglee1', 'SYS0012', 'main', 'SEARCH', out_cursor]
    )
    result_cursor = out_cursor.getvalue()
    rows = result_cursor.fetchall()
    cols = [d[0] for d in result_cursor.description]
    for r in rows:
        print(f"  {dict(zip(cols, r))}")
except Exception as e:
    print(f"  ⚠ SP 호출 실패: {e}")

# Q4. 풀 권한 trace (USER_M / USER_GR_MPG_M / USER_GR_MNU_BTN_MPG_M)
print("\n[ Q4 ] minyonglee1 권한 풀 trace:")
print("\n  Q4.1 SCM_ADM_USER_M (사용자 정보):")
cur.execute(
    "SELECT USER_ID, USER_NM, USE_YN FROM SCM_MGR.SCM_ADM_USER_M WHERE USER_ID='minyonglee1'"
)
for r in cur.fetchall():
    print(f"    {r}")

print("\n  Q4.2 SCM_ADM_USER_GR_MPG_M (사용자→그룹):")
cur.execute(
    "SELECT USER_ID, USER_GR_ID, USE_YN FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M WHERE USER_ID='minyonglee1'"
)
for r in cur.fetchall():
    print(f"    {r}")

print("\n  Q4.3 SYS0012 BTN_MPG_M 의 USE_YN 분포:")
cur.execute(
    "SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M "
    "WHERE MNU_ID='SYS0012' ORDER BY SHT_NM, MNU_BTN_CD"
)
for r in cur.fetchall():
    print(f"    {r}")

conn.close()
print("\n[ done ] SYS0012 권한 체크 trace 완료 (read-only).")
print("\n[ 권고 ]")
print("  Q1 row 0 → 25 스크립트 실행 필요 (가설 A)")
print("  Q3 'N' + Q1 row 있음 → BE 캐시 stale, BE 재시작 필요 (가설 B)")
print("  Q3 'N' + Q1 row 있음 + Q2 body 가 BTN_CD literal 분기 (예: WHERE MNU_BTN_CD = 'SAVE') → BTN_CD 표준만 인식 (가설 C)")
print("  Q4.3 USE_YN='N' → BTN_MPG_M 비활성 (가설 D)")
